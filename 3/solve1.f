      program solve1
         use funcs
         implicit none

         character(len=200) :: twopacks, firstpack, secondpack, line
         integer :: status, packlength, twopackslength, sum = 0

         open(1, file = "data.txt", status = "old")

         do
            read(1, '(A)', IOSTAT = status) line
            if (IS_IOSTAT_END(status)) exit

            twopacks = trim(line)

            twopackslength = len_trim(twopacks)

            packlength = twopackslength / 2

            firstpack = twopacks(:packlength)
            secondpack = twopacks(packlength+1:)

            sum = sum + priority(firstpack, secondpack)

         end do


         print *, sum
         close(1)
      end program solve1   

