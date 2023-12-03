#! /bin/bash
usdf(){
	usd=`echo $1 | sed ':a;s/\B[0-9]\{3\}\>/,&/;ta' | sed 's/^/$/' | sed 's/$/ USD/'`

}
compare_dates(){
							        if [[ $1 -eq $(date +%Y) && $2 -gt $(date +%m) ]]
									        then
											                expiry_check=active
													        else
															                expiry_check=expired
																	        fi
																	}
while IFS="," read -r card_type_code card_type_full_name issuing_bank card_number card_holder_name cvv issue_date expiry_date billing_date card_pin credit_limit;
																	do
																		    last_year="${expiry_date:3:6}"
																		    last_month=$[$((10#${expiry_date:0:2}))]

																			    compare_dates "$last_year" "$last_month"
																				usdf "$credit_limit"

																			        parent_directory=$(echo "$card_type_full_name" | sed 's/ /_/g')
																				    child_directory=$(echo "$issuing_bank" | sed 's/ /_/g;t')

																				        mkdir -p "$parent_directory/$child_directory"
																					    cd "$parent_directory/$child_directory"

																					        if [ "$expiry_check" = 'active' ]; then
																							        cat > "$card_number.active" <<EOF
Card Type Code: $card_type_code
Issuing Bank: $issuing_bank
Card Number: $card_number
Card Holder's Name: $card_holder_name
CVV/CVV2: $cvv
Expiry Date: $expiry_date
Billing Date: $billing_date
Card PIN: $card_pin
Credit Limit: $credit_limit
EOF
    else
	            cat > "$card_number.expiry" <<EOF
Card Type Code: $card_type_code
Card Type Full Name: $card_type_full_name
Issuing Bank: $issuing_bank
Card Number: $card_number
Card Holder's Name: $card_holder_name
CVV/CVV2: $cvv
Expiry Date: $expiry_date
Billing Date: $billing_date
Card PIN: $card_pin
Credit Limit: $credit_limit
EOF
    fi

        cd ..

	    cd ..
    done < <(tail -n +2 "Records.csv")


