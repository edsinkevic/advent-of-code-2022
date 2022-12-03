      program solve2
         use funcs
         implicit none

         character(len=200) :: first, second, third
         integer :: stat, sum = 0

         open(1, file = "data.txt", status = "old")

         do
            read(1, '(A)', IOSTAT = stat) first
            if (IS_IOSTAT_END(stat)) exit
            read(1, '(A)', IOSTAT = stat) second
            if (IS_IOSTAT_END(stat)) exit
            read(1, '(A)', IOSTAT = stat) third
            if (IS_IOSTAT_END(stat)) exit
            sum = sum + priority2(first, second, third)
         end do


         print *, sum
         close(1)
      end program solve2

