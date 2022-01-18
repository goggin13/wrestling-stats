module MatchesHelper
  def name_with_rank(college)
    result = college.name
    if college.dual_rank
      result += " (#{college.dual_rank})"
    end

    result
  end
end
