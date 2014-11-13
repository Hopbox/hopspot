use utf8;
package HopSpot::Schema::PgDB::Result::Gwcontroller;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HopSpot::Schema::PgDB::Result::Gwcontroller

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

=head1 TABLE: C<gwcontrollers>

=cut

__PACKAGE__->table("gwcontrollers");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'gwcontrollers_id_seq'

=head2 controller_id

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

=head2 sys_load

  data_type: 'numeric'
  is_nullable: 1

=head2 sys_memfree

  data_type: 'integer'
  is_nullable: 1

=head2 sys_uptime

  data_type: 'integer'
  is_nullable: 1

=head2 cp_uptime

  data_type: 'integer'
  is_nullable: 1

=head2 status

  data_type: 'text'
  default_value: 'AUTO_CREATED_ON_PING'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "gwcontrollers_id_seq",
  },
  "controller_id",
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
  "sys_load",
  { data_type => "numeric", is_nullable => 1 },
  "sys_memfree",
  { data_type => "integer", is_nullable => 1 },
  "sys_uptime",
  { data_type => "integer", is_nullable => 1 },
  "cp_uptime",
  { data_type => "integer", is_nullable => 1 },
  "status",
  {
    data_type     => "text",
    default_value => "AUTO_CREATED_ON_PING",
    is_nullable   => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<gwcontrollers_controller_id_key>

=over 4

=item * L</controller_id>

=back

=cut

__PACKAGE__->add_unique_constraint("gwcontrollers_controller_id_key", ["controller_id"]);

=head1 RELATIONS

=head2 otpcaches

Type: has_many

Related object: L<HopSpot::Schema::PgDB::Result::Otpcache>

=cut

__PACKAGE__->has_many(
  "otpcaches",
  "HopSpot::Schema::PgDB::Result::Otpcache",
  { "foreign.gw_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sessions

Type: has_many

Related object: L<HopSpot::Schema::PgDB::Result::Session>

=cut

__PACKAGE__->has_many(
  "sessions",
  "HopSpot::Schema::PgDB::Result::Session",
  { "foreign.gw_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users_first_seen_gws

Type: has_many

Related object: L<HopSpot::Schema::PgDB::Result::User>

=cut

__PACKAGE__->has_many(
  "users_first_seen_gws",
  "HopSpot::Schema::PgDB::Result::User",
  { "foreign.first_seen_gw" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 users_last_seen_gws

Type: has_many

Related object: L<HopSpot::Schema::PgDB::Result::User>

=cut

__PACKAGE__->has_many(
  "users_last_seen_gws",
  "HopSpot::Schema::PgDB::Result::User",
  { "foreign.last_seen_gw" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-12 13:14:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:gz2vBFZ39ZFhsWZU9H1xuQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
