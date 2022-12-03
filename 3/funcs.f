      module funcs

         implicit none
      contains

         pure integer function priority(firstpack, secondpack)
            character(len=*), intent(in) :: firstpack, secondpack
            character(len=4) :: mistake, notfound
            integer :: packlength, indexresult, i
            character(len=100) :: types

            notfound = "None"
            packlength = len_trim(firstpack)
            types = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

            do i = 0, packlength
               indexresult = index(secondpack, firstpack(i:i))
               if (indexresult > 0) then
                  mistake = secondpack(indexresult:indexresult)
                  exit
               end if
            end do

            priority = index(types, trim(mistake))

         end function priority

         integer function priority2(first, second, third)
            character(len=*), intent(in) :: first, second, third
            character(len=4) :: solution, notfound, currentchar
            integer :: packlength, secondresult, thirdresult, i
            character(len=100) :: types

            notfound = "None"
            packlength = len_trim(first)
            types = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

            do i = 0, packlength
               currentchar = first(i:i)
               secondresult = index(second, trim(currentchar))
               thirdresult = index(third, trim(currentchar))
               if (secondresult > 0 .and. thirdresult > 0) then
                  solution = currentchar
                  exit
               end if
            end do
            priority2 = index(types, trim(solution))

         end function priority2
      end module funcs
