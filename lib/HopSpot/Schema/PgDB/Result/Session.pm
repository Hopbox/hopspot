use utf8;
package HopSpot::Schema::PgDB::Result::Session;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HopSpot::Schema::PgDB::Result::Session

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

=head1 TABLE: C<sessions>

=cut

__PACKAGE__->table("sessions");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'sessions_id_seq'

=head2 token

  data_type: 'text'
  is_nullable: 1

=head2 mac

  data_type: 'text'
  is_nullable: 1

=head2 ip

  data_type: 'text'
  is_nullable: 1

=head2 gw_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 mobile

  data_type: 'integer'
  is_nullable: 1

=head2 status

  data_type: 'text'
  is_nullable: 1

=head2 in_bytes

  data_type: 'integer'
  is_nullable: 1

=head2 out_bytes

  data_type: 'integer'
  is_nullable: 1

=head2 start_time

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 last_update

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "sessions_id_seq",
  },
  "token",
  { data_type => "text", is_nullable => 1 },
  "mac",
  { data_type => "text", is_nullable => 1 },
  "ip",
  { data_type => "text", is_nullable => 1 },
  "gw_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "mobile",
  { data_type => "integer", is_nullable => 1 },
  "status",
  { data_type => "text", is_nullable => 1 },
  "in_bytes",
  { data_type => "integer", is_nullable => 1 },
  "out_bytes",
  { data_type => "integer", is_nullable => 1 },
  "start_time",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "last_update",
  { data_type => "timestamp", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 gw

Type: belongs_to

Related object: L<HopSpot::Schema::PgDB::Result::Node>

=cut

__PACKAGE__->belongs_to(
  "gw",
  "HopSpot::Schema::PgDB::Result::Node",
  { id => "gw_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-11 11:23:08
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MJdqchOd/y70ONrylFVRZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
