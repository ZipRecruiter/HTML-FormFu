package HTML::FormFu::Transformer;

use strict;
use warnings;
use base 'Class::Accessor::Chained::Fast';

use HTML::FormFu::Accessor qw( mk_output_accessors );
use HTML::FormFu::Exception::Transformer;
use HTML::FormFu::ObjectUtil qw( populate form name );
use Scalar::Util qw/ blessed /;
use Carp qw/ croak /;

__PACKAGE__->mk_accessors(qw/ parent transformer_type localize_args /);

__PACKAGE__->mk_output_accessors(qw/ message /);

sub new {
    my $class = shift;

    my %attrs;
    eval { %attrs = %{ $_[0] } if @_ };
    croak "attributes argument must be a hashref" if $@;

    my $self = bless {}, $class;

    for (qw/ transformer_type /) {
        croak "$_ attribute required" if !exists $attrs{$_};
    }

    $self->populate( \%attrs );

    return $self;
}

sub process {
    my ( $self, $values ) = @_;

    my $return;
    my @errors;

    if ( ref $values eq 'ARRAY' ) {
        my @return;
        for my $value ( @$values ) {
            my ( $return ) = eval {
                $self->transformer($value);
                };
            if ( $@ ) {
                push @errors, $self->return_error($@);
                push @return, undef;
            }
            else {
                push @return, $value;
            }
        }
        $return = \@return;
    }
    else {
        ( $return ) = eval {
            $self->transformer($values);
            };
        if ( $@ ) {
            push @errors, $self->return_error($@);
        }
    }

    return ( $return, @errors );
}

sub clone {
    my ( $self ) = @_;
    
    my %new = %$self;
    
    return bless \%new, ref $self;
}

sub return_error {
    my ( $self, $err ) = @_;
    
    if ( !blessed $err || !$err->isa('HTML::FormFu::Exception::Transformer') ) {
        $err = HTML::FormFu::Exception::Transformer->new;
    }
    
    return $err;
}


1;

__END__

=head1 NAME

HTML::FormFu::Transformer - Transformer Base Class

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head1 CORE TRANSFORMERS

=head1 AUTHOR

Carl Franks, C<cfranks@cpan.org>

=head1 LICENSE

This library is free software, you can redistribute it and/or modify it under
the same terms as Perl itself.