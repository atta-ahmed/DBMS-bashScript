#!/bin/bash
# Atta Ahmed <atta7739@gmail.com>
# Samar Ammar
#------------------------------------------------------------------#
function createDb()
{
  read -p "enter data base name " dbname

    mkdir $dbname
    if [ $? == 0 ]
    then
      echo " $dbname created Successfully"
    else
      echo "failed to created"
    fi
}

function useDb()
{
  read -p "enter DataBase name " filename;
  if [ -f $tabelname ]
    then

      cd $filename;
        if [ $? == 0 ]
        then
          echo " ------------- Database $filename Selected --------------------- "
        else
          echo " ---------------- not founded !! -------------- "
        fi
     else
       echo " ---------------- not founded !! -------------- "
   fi

}

function createTb()
{
  read -p "enter table name " tabelname;
  touch $tabelname;

  read -p "enter col number " colNumber;
for (( i = 0; i < $colNumber; i++ )); do

  read -p "enter coluom   " coluom;
  colHeadArr[i]=$coluom;
  read -p "enter type int  or  str ====>  " typee ;
  typeeArr[i]=$typee;
done

for (( i = 0; i < $colNumber; i++ )); do
  echo -n ${colHeadArr[i]}":">>$tabelname;
done

echo " ">>$tabelname;
for (( i = 0; i < $colNumber; i++ )); do
  #statements
  # echo "header " ${colHeadArr[i]};
  # echo "typee " ${typeeArr[i]};
  echo -n ${typeeArr[i]}":">>$tabelname;
done
echo " ">>$tabelname;


}


validateInt(){
  if [[  $1 =~ ^-?[0-9]+$ ]];
# if [  $1 -eq $1 2>/dev/null ]
    then
        echo "Please Enter A Valid Number"
          break
      else
        echo ""
    fi
}


echo "Choose from the following:"
 select choice in creat-database use-database DeleteDataBase RenameDataBase ShowDataBases Exite
 do
 case $choice in
 creat-database)
      createDb;;
      #////////////////////////////////////////////////////////////////////////
      DeleteDataBase)
        read -p "enter DataBase name "
        rm -r $REPLY
        if [ $? == 0 ]
        then
          echo "Deleted Successfully"
        else
          echo "failed to delete"
        fi
        ;;
        #/////////////////////////////////////////////////////////////////////
        RenameDataBase)
        read -p "enter DataBase name " oldname
        read -p "enter new DataBase name " newname

         mv  $oldname $newname
         if [ $? == 0 ]
         then
           echo "Done Successfully"
         else
           echo "failed to rename"
         fi
         ;;
        #////////////////////////////////////////////////////////////////////
        ShowDataBases)
         ls
         ;;
         #//////////////////////////////////////////////////////////////////

        use-database)
        useDb

     	 select choice in creat-table show-tables desc-table DropTable Insert SelectAll SelectColumn SelectWhere Update Delete Exite
            do
              case $choice in
          #////////////////////////////////////////////////////////////////
                creat-table)
                  createTb;;
            #////////////////////////////////////////////////////////////////
    			  show-tables)
              ls
              ;;
            #////////////////////////////////////////////////////////////////
    			  desc-table)
              read -p "enter table name " tabelname;
               awk 'NR==1' $tabelname ;
    			        ;;
            #////////////////////////////////////////////////////////////////
             DropTable)
                    read -p "enter table name " tabelname;
                    read -p "are you sure to delete table ? y/n"
                    if [ $REPLY = 'y' ]
                    then
                      rm $tabelname
                      if [ $? == 0 ]
                      then
                        echo "Done Successfully"
                      else
                        echo "failed to remove"
                      fi
                    fi
              ;;
            #////////////////////////////////////////////////////////////////
             Insert)
                   read -p "enter table name " tabelname
                    if [ -f $tabelname ]
                      then
                        arr=($(awk -F: '{ for(i = 1; i <= NF; i++) { if (NR==1) print $i; } }' $tabelname));

                        for (( i = 0; i <${#arr[@]} ; i++ )); do

                          let " feildNum = i + 1 "
                          read -p "========> enter ${arr[i]} ==> " input;
                           inputType=$(awk -F: '{ if (NR==2) print  $"'"$feildNum"'" }' $tabelname);
                           echo $inputType
                           if [[ $inputType == 'int' ]]; then
                             validateInt $inpute
                            fi
                          echo -n $input":">>$tabelname;
                        done
                        echo " ">>$tabelname
                        echo "---------------------- done ---------------------- "
                      else
                         echo " dosen't exist "
                      fi
            ;;
            #////////////////////////////////////////////////////////////////
            SelectAll)
              if [ -f $tabelname ]
                then
                    read -p "enter table name " tabelname;
                    echo " ======================================== "
                    sed -n '3,$p' $tabelname
                    echo " ======================================== "

                else
                   echo " dosen't exist "
                fi
             ;;
            #////////////////////////////////////////////////////////////////
            SelectColumn)
                read -p "enter table name " tabelname;
                if [ -f $tabelname ]
                  then

                  fieldNum=$(awk -F: '{if (NR==1) print NF; }' $tabelname);

                     arr=($(awk -F: '{ for(i = 1; i <= NF; i++) { if (NR==1) print $i; } }' $tabelname));

                  for (( i = 0; i <${#arr[@]}; i++ )); do
                    let "x = i + 1";
                    echo $x" == "${arr[i]};
                    #statements
                  done
                  read -p "select column number " colNum;
                  awk -F: '{print $"'"$colNum"'"}' $tabelname;
                  echo "done";
                else
                  echo " table dos not exist "
                fi

             ;;
             #//////////////////////////////////////////////////////////
             SelectWhere)
                 read -p "enter table name " tabelname;
                 if [ -f $tabelname ]
                   then
                  #get the field number and store it in array
                   fieldNum=$(awk -F: '{if (NR==1) print NF; }' $tabelname);
                   arr=($(awk -F: '{ for(i = 1; i <= NF; i++) { if (NR==1) print $i; } }' $tabelname));

                   #print column for user
                   for (( i = 0; i <${#arr[@]}; i++ )); do
                     let "x = i + 1";
                     echo $x" == "${arr[i]};
                   done

                   # x is number of column
                   let "x += 1";
                   echo $x" == All";
                   read -p "select column number " colNum;
                   let "var = ${#arr[@]} + 1";

                   #enter where condition as 'name = str'
                   read -p "where what ex: 'id = 1' " condition;
                   conArr=($condition) ;

                     #find column  that where cpditon on it
                  for (( i = 0; i <${#arr[@]}; i++ )); do
                      let "y = i + 1 ";
                      if [ "${arr[i]}" == "${conArr[0]}" ];
                        then
                          break
                      fi
                  done
                  let "colname = colNum - 1 ";

                  #check if user select specifec column or select all
                       if [[ $colNum<$var ]]; then
                        # awk -F: -v test=${conArr[2]} '{ if (match($"'"$y"'", test)) print "'${arr[$colname]}'->" ,$"'"$colNum"'" }' $tabelname;
                        echo $(awk -F: -v test=${conArr[2]} '{ if (match($"'"$y"'", test)) print  "==> '${arr[$colname]}'= " ,$"'"$colNum"'" }' $tabelname);
                        elif [[ $colNum -eq $var ]]; then
                        echo $(awk -F: -v test=${conArr[2]} '{ if (match($"'"$y"'", test)) print }' $tabelname);
                        fi
                    else
                        echo "dos not exist "
              fi

              ;;
              #//////////////////////////////////////////////////////////
              Update)
                  read -p "enter table name " tabelname;
                  if [ -f $tabelname ]
                    then

                   #get the field number and store it in array
                    arr=($(awk -F: '{ for(i = 1; i <= NF; i++) { if (NR==1) print $i; } }' $tabelname));

                    read -p "where what ex: 'id = 1' " condition;

                    conArr=($condition) ;

                      #calc column number that user select
                   for (( i = 0; i <${#arr[@]}; i++ )); do
                       let "y = i + 1 ";
                       echo "arr "${arr[i]}
                       echo "condition "${conArr[0]}
                      if [ "${arr[i]}" == "${conArr[0]}" ];
                      then
                         break
                       fi
                   done

                   echo "coloum of condition " ${arr[y]};

                   let "colname = colNum - 1 ";
                   read -p "enter new val = " new
                  #  echo "valtype "$valType
                  #  awk -F: -v test=${conArr[2]} -v test2=$new '{ gsub( "test","test2",$'$y'); print }' $tabelname;
                  #  awk -F: -v test=${conArr[2]} -v test2=$new '{ if(NF=$'$y') {if ( test==test2 )  sed -i 's/${conArr[2]}/$new/g' } }' $tabelname;
                   sed -i "s/${conArr[2]}/$new/g" $tabelname;
                #  awk -F: -v test=${conArr[2]} '{ if (match($"'"$y"'", test)) print "'${arr[$colname]}'->" ,$"'"$colNum"'" }' $tabelname;
                  echo "updated "
                     else
                         echo "dos not exist "
               fi

               ;;
              #/////////////////////////////////////////////////////////
              Delete)
              read -p"enter table name" tabelname;
              if [ -f $tabelname ]
                then
                    arr=($(awk -F: '{ for(i = 1; i <= NF; i++) { if (NR==1) print $i; } }' $tabelname));
                    #enter where condition as 'name = str'
                    read -p "where what ex: 'id = 1' " condition
                    conArr=($condition)
                    # echo "arr "${arr[i]}
                    # echo "condition "${conArr[0]}

                      #calc column number that user select
                   for (( i = 0; i <${#arr[@]}; i++ )); do
                       let "y = i + 1 "
                      #  echo "arr "${arr[i]}
                      #  echo "condition "${conArr[0]}
                      #  if ((${arr[i]}=${conArr[0]}))
                      if [ "${arr[i]}" == "${conArr[0]}" ];
                         then
                         break;
                       fi
                   done
                  #  echo "y "$y
                  lineVal=$(awk -F: '{ if ($'$y'=="'${conArr[2]}'") print NR }' $tabelname);

                  #  echo "linevalue "$lineVal;
                    sed -i "$lineVal d" $tabelname;
                    echo "done"
                  else
                    echo "not exist "
                  fi
                ;;
               #//////////////////////////////////////////////
              Exite)
                cd ../
                break
              ;;
            #//////////////////////////////////////////
           *)
            echo "$REPLY is not one of the choices."
            echo "Try again"
             ;;
           esac
            done
             ;;
     #////////////////////////////////////////////////////////////////
   Exite)
     exit
   ;;
   #//////////////////////////////////////////////////////////////////
   *) echo "$REPLY is not one of the choices."
    echo "Try again"
    ;;
 esac
 done
