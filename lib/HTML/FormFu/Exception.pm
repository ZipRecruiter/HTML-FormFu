package HTML::FormFu::Exception;

use strict;
use warnings;
use base 'Class::Accessor::Chained::Fast';

use HTML::FormFu::Exception::Constraint;
use HTML::FormFu::ObjectUtil qw/ form /;

__PACKAGE__->mk_accessors(qw/ type class parent /);

1;