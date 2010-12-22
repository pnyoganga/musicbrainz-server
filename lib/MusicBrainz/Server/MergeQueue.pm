package MusicBrainz::Server::MergeQueue;
use Moose;
use namespace::autoclean;

has 'type' => (
    isa => 'Str',
    is => 'ro',
    required => 1
);

has 'entities' => (
    isa => 'ArrayRef',
    is => 'ro',
    default => sub { [] },
    traits => [ 'Array' ],
    handles => {
        _add_entities => 'push',
        entity_count => 'count',
        all_entities => 'elements'
    }
);

sub ready_to_merge {
    my $self = shift;
    return $self->entity_count >= 2;
}

sub add_entities {
    my ($self, @entities) = @_;
    my %all_existing = map { $_ => 1 } $self->all_entities;
    my %new = map { $_ => 1 }
        grep { !exists $all_existing{ $_ } } @entities;
    $self->_add_entities(keys %new);
}

1;
