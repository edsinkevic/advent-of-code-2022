      program hello
         use funcs
         implicit none

         integer :: stat
         character(len=200) :: twopacks
         character(len=200) :: firstpack
         character(len=200) :: secondpack
         character(len=200) :: line
         integer :: packlength
         integer :: twopackslength
         integer :: sum = 0

         open(1, file = "data.txt", status = "old")

         do
            read(1, '(A)', IOSTAT = stat) line
            if (IS_IOSTAT_END(stat)) exit

            twopacks = trim(line)

            twopackslength = len_trim(twopacks)

            packlength = twopackslength / 2

            firstpack = twopacks(:packlength)
            secondpack = twopacks(packlength+1:)

            sum = sum + priority(firstpack, secondpack)

         end do


         print *, sum
         close(1)
      end program hello

