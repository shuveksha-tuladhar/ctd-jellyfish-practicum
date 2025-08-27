module UserGroupsHelper
  def group_member_count(group)
    group.group_members.count
  end

  def group_creator_name(group)
    "#{group.creator.first_name} #{group.creator.last_name}"
  end
end
