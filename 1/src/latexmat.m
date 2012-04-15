function str = latexmat( mat, format )
%LATEXMAT Generate LaTeX code of a matrix.
%
% STR = LATEX( MAT, FORMAT ) return the LaTeX code to the matrix MAT,
% with the given FORMAT. The parameter FORMAT is one of the following
% data types: d, i, o, u, x, X, f, e, E, g, G, c, and s.
%
% See HELP SPRINTF for more details about the FORMAT parameter.

% 1997-09-20 23:09:53 Peter John Acklam <jacklam@math.uio.no>

if isstr(mat)
   error( 'First argument can not string.' );
end

if ~isstr(format)
   error( 'Second argument must be a string.' );
end

[ r, c ] = size( mat );

if isunix
   newline = setstr( 10 ); % Unix
elseif isvms
   newline = setstr( 13 ); % VMS
else
   newline = setstr( [ 13 10 ] ); % MS-DOS
end

str = [ '\left[ \begin{array}{' ...
            setstr(abs('c')*ones(1,c)) '}' newline ];

for i = 1:r
   str = [ str ' ' ];
   for j = 1:c
      t = sprintf( format, real(mat(i,j)) );
      if ( imag(mat(i,j)) > 0 )
         t = [ t '+' sprintf( format, imag(mat(i,j)) ) 'i' ];
      elseif ( imag(mat(i,j)) < 0 )
         t = [ t '-' sprintf( format, -imag(mat(i,j)) ) 'i' ];
      end
      str = [ str ' ' t ];
      if j < c
         str = [ str ' &' ];
      else
         if i < r
            str = [ str ' \\' newline ];
         else
            str = [ str newline ];
         end
      end
   end
end
str = [ str '\end{array} \right]' newline ]; 
