      module funcs

         implicit none
      contains

         pure integer function priority(firstpack, secondpack)
            character(len=*), intent(in) :: firstpack
            character(len=*), intent(in):: secondpack
            character(len=4) :: mistake
            character(len=4) :: notfound
            integer :: packlength
            integer :: indexresult
            character(len=100) :: types
            integer :: i

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
      end module funcs
