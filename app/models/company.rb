# == Schema Information
#
# Table name: companies
#
#  id             :bigint(8)        not null, primary key
#  children_count :integer          default(0), not null
#  depth          :integer          default(0), not null
#  lft            :integer          not null
#  name           :string(255)
#  rgt            :integer          not null
#  parent_id      :integer
#
# Indexes
#
#  index_companies_on_lft        (lft)
#  index_companies_on_parent_id  (parent_id)
#  index_companies_on_rgt        (rgt)
#

class Company < ApplicationRecord
  acts_as_nested_set
  has_many :users
  scope :top_level, ->{where(parent_id: nil)}
  scope :with_users, ->{includes(:users)}
  scope :with_children, ->{eager_load(:children)}
end
