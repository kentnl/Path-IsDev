
use strict;
use warnings;

package Path::IsDev::Role::Debug;
use v5.10;
use Moo::Role;

require Scalar::Util;

use macro _refaddr => sub { \&Scalar::Util::refaddr($_[0]) }; 
#    _need_scalar_util();
#    Scalar::Util::refaddr( $_[0] );
#};
use macro _weaken => sub {
    require Scalar::Util;
    Scalar::Util::weaken( $_[0] );
};
use macro _blessed => sub {
    require Scalar::Util;
    Scalar::Util::blessed( $_[0] );
};
use macro class_from => sub {
    _blessed( $_[0] ) ? _blessed( $_[0] ) : $_[0];
};

use MooX::ClassAttribute;

class_has _debug_env_key => (
    is      => ro =>,
    lazy    => 1,
    builder => sub {
        my ($self) = @_;
        my $classname = class_from($self);
        $classname = uc($classname);
        $classname =~ s/::/_/g;
        $classname .= '_DEBUG';
        return $classname;
    }
);

class_has '_debugging' => (
    is      => ro =>,
    lazy    => 1,
    builder => sub {
        my ($self) = @_;
        my $key = $self->_debug_env_key;
        return unless exists $ENV{$key};
        return !!$ENV{$key};
    },
);

our $REFADDR_TABLE = {};

use macro class_refaddrs => sub {
    my $class = class_from($_[0]);
    ( ( exists $REFADDR_TABLE->{$class} ) ? (  $REFADDR_TABLE->{$class} ) : ( $REFADDR_TABLE->{$class} = {} ));
};

our $INSTANCE_TABLE = {};

use macro class_next_instance_id => sub {
    my $class = class_from($_[0]);
    exists $INSTANCE_TABLE->{$class} ? () :  ( $INSTANCE_TABLE->{$class} = 0 ); 
    my $id = $INSTANCE_TABLE->{$class};
    $INSTANCE_TABLE->{$class}++;
    sprintf '%x', $id;
};

use macro instance_refaddr => sub {
    sprintf '%x', _refaddr($_[0]);
};

use macro instance_id => sub {
    my $addr   = instance_refaddr($_[0]);
    my $table  = class_refaddrs($_[0]);
    (( exists $table->{$addr} ) ? ( $table->{$addr} ) : (  $table->{$addr} = class_next_instance_id($_[0]) ));
};

sub _instance_id { instance_id(@_) }

sub _instance_tag {
    my $id     = instance_id($_[0]);
    my $class  = class_from($_[0]);
    return qq{$class=$id};
}

sub _instance_debug {
    my ( $self, $message ) = @_;
        return unless $self->_debugging;
        return *STDERR->printf( qq{[%s] %s\n}, $self->_instance_tag, $message );
}

our $INSTANCE_MAXES = {};

sub _class_attr_padname {
    my ( $self, $attr ) = @_;
    my $class = class_from($self);
    my $alen  = length $attr;
    if ( not exists $INSTANCE_MAXES->{$class} ) {
        $INSTANCE_MAXES->{$class} = $alen;
        return $attr;
    }
    $INSTANCE_MAXES->{$class} = $alen if $INSTANCE_MAXES->{$class} < $alen;
    return $attr . ( ' ' x ( $INSTANCE_MAXES->{$class} - $alen ) );
}

sub _instance_debug_prop_line {
    my ( $self, $name ) = @_;
    my $has_form = "has_$name";
    if ( $self->can($has_form) and not $self->$has_form ) {
        return;
    }
    my $formatted = $self->_class_attr_padname($name) . ' => ';
    my $value     = $self->$name;
    if ( not defined $value ) {
        return $formatted . 'undef';
    }
    if ( not ref $value ) {
        return $formatted . $value;
    }
    require Scalar::Util;
    my $bless = Scalar::Util::blessed($value);
    if ( not $bless ) {
        return $formatted . $value;
    }
    if ( $value->can('_instance_tag') ) {
        return $formatted . $value->_instance_tag;
    }
    return $formatted . $value;
}

