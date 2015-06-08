c This subroutine is called by SUM_ARRAY and has no IDL-specific code.
c
      SUBROUTINE sumarray1(array, n, sum)
      INTEGER*4 n
      REAL*4 array(n), sum
      
      sum=0.0
      DO i=1,n
         sum = sum + array(i)
         PRINT *, sum, array(i)
      ENDDO
      
      RETURN
      END
