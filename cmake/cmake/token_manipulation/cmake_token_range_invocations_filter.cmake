
function(cmake_token_range_invocations_filter range)
  arguments_encoded_list2(1 ${ARGC})
  ans(args)

  cmake_token_range("${range}")
  ans_extract(current end)

  list_extract_labelled_keyvalue(args --skip)
  ans(skip)
  list_extract_labelled_keyvalue(args --take)
  ans(take)
  if("${take}_" STREQUAL "_")
    set(take -1)
  endif()

  set(result)
  while(take AND current)

    cmake_token_range_filter("${current};${end}" {type} STREQUAL "command_invocation" --take 1)
    ans(invocation_token)
    if(NOT invocation_token)
      break()
    endif()

    cmake_token_range_filter("${invocation_token};${end}" {type} STREQUAL "nesting" --take 1)
    ans(arguments_begin_token)

    map_tryget(${arguments_begin_token} end)
    ans(arguments_end_token)
    map_tryget(${arguments_end_token} next)
    ans(arguments_after_end_token)

    cmake_token_range_filter_values("${invocation_token};${arguments_after_end_token}" {type} MATCHES "(command_invocation)|(nesting)|(argument)")
    ans(invocation)

    ## get invocation_identifier and invocation_arguments
    set(invocation_arguments ${invocation})
    list_pop_front(invocation_arguments)
    ans(invocation_identifier)
    list_pop_front(invocation_arguments)
    list_pop_back(invocation_arguments)
    

    eval_predicate(${args})
    ans(predicate_holds)
    ## check if invocation matches the custom predicate
    ## skip and take the specific invocations
    if(predicate_holds)
      if(skip)
        math(EXPR skip "${skip} - 1")
      else()
        cmake_token_advance(arguments_begin_token)
        map_capture_new(
          invocation_identifier 
          invocation_arguments 
          invocation_token 
          arguments_begin_token 
          arguments_end_token
        )
        ans_append(result)
        if(${take} GREATER 0)
          math(EXPR take "${take} - 1")
        endif()
      endif() 
    endif() 


    set(current ${arguments_after_end_token})
  endwhile()
  return_ref(result)
endfunction()
