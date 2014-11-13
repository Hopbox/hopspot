use utf8;
package HopSpot::Schema::PgDB::Result::Otpcache;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

HopSpot::Schema::PgDB::Result::Otpcache

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

=head1 TABLE: C<otpcache>

=cut

__PACKAGE__->table("otpcache");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'otpcache_id_seq'

=head2 mac

  data_type: 'text'
  is_nullable: 1

=head2 mobile

  data_type: 'text'
  is_nullable: 1

=head2 gw_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 gw_name

  data_type: 'text'
  is_nullable: 1

=head2 ip

  data_type: 'text'
  is_nullable: 1

=head2 otp

  data_type: 'integer'
  is_nullable: 1

=head2 url

  data_type: 'text'
  is_nullable: 1

=head2 sent_time

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 resent_count

  data_type: 'integer'
  is_nullable: 1

=head2 last_resent_time

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "otpcache_id_seq",
  },
  "mac",
  { data_type => "text", is_nullable => 1 },
  "mobile",
  { data_type => "text", is_nullable => 1 },
  "gw_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "gw_name",
  { data_type => "text", is_nullable => 1 },
  "ip",
  { data_type => "text", is_nullable => 1 },
  "otp",
  { data_type => "integer", is_nullable => 1 },
  "url",
  { data_type => "text", is_nullable => 1 },
  "sent_time",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "resent_count",
  { data_type => "integer", is_nullable => 1 },
  "last_resent_time",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
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

Related object: L<HopSpot::Schema::PgDB::Result::Gwcontroller>

=cut

__PACKAGE__->belongs_to(
  "gw",
  "HopSpot::Schema::PgDB::Result::Gwcontroller",
  { id => "gw_id" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-12 14:00:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6tKI8zVXzXoZARhwg21LoA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
