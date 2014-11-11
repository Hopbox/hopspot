use utf8;
package HopSpot::Schema::PgDB::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HopSpot::Schema::PgDB::Result::User

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'users_id_seq'

=head2 mac

  data_type: 'text'
  is_nullable: 1

=head2 first_seen_gw

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 last_seen_gw

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 mobile

  data_type: 'text'
  is_nullable: 1

=head2 first_seen

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 last_seen

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "users_id_seq",
  },
  "mac",
  { data_type => "text", is_nullable => 1 },
  "first_seen_gw",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "last_seen_gw",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "mobile",
  { data_type => "text", is_nullable => 1 },
  "first_seen",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "last_seen",
  { data_type => "timestamp", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 first_seen_gw

Type: belongs_to

Related object: L<HopSpot::Schema::PgDB::Result::Node>

=cut

__PACKAGE__->belongs_to(
  "first_seen_gw",
  "HopSpot::Schema::PgDB::Result::Node",
  { id => "first_seen_gw" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 last_seen_gw

Type: belongs_to

Related object: L<HopSpot::Schema::PgDB::Result::Node>

=cut

__PACKAGE__->belongs_to(
  "last_seen_gw",
  "HopSpot::Schema::PgDB::Result::Node",
  { id => "last_seen_gw" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-11 11:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:RpLV4YGNi3sQubqoMZviVQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
