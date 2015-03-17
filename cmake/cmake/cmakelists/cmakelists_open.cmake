
function(cmakelists_open)
  map_new()
  ans(cmakelists)

  file_find_anchor("CMakeLists.txt" ${ARGN})
  ans(cmakelists_path)
  if(NOT cmakelists_path)
    path("CMakeLists.txt")
    ans(cmakelists_path)
    set(content "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n\nproject(${project_name})\n## <section name=\"targets\">\n## </section>\n")
  else()
    fread("${cmakelists_path}")
    ans(content)
  endif()

  cmake_token_range("${content}")
  ans_extract(begin end)    
  map_set(${cmakelists} begin ${begin})
  map_set(${cmakelists} end ${end} )
  map_set(${cmakelists} path "${cmakelists_path}")
  return_ref(cmakelists)
endfunction()