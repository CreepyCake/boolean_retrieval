Boolean retrieval written in Ruby.
Program parses text out of html-files, makes reverse index of the text (each token has array of document numbers).
Three boolean operations: 
'token' AND 'token' (intersection of arrays of numbers);
'token' OR 'token' (union of arrays);
NOT 'token' (substration of 'token' array from array that contains all the document numbers).
