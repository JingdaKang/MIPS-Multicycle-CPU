module WriteNext(Reverse,Zero,PCWriteCond,PCWr,write_next);
  input Reverse;
  input Zero;
  input PCWriteCond;
  input PCWr;
  
  output write_next;
  
  assign write_next=((Reverse^Zero)&&PCWriteCond)||PCWr;
endmodule
