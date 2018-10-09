json.swaps @swaps do |swap|
  json.partial! 'swaps/show', swap: swap
end
json.roles @roles