@font-face {
    font-family: 'Avenir';
    src: url('../Fonts/AvenirLTStd-Roman.otf'); 
} 



body {
    font-family: 'Avenir', sans-serif;
    margin: 0;
    padding: 0;
    color: white;
}


::-webkit-scrollbar {
    display: none; /*Hide scrollbar*/
}



/*Main*/
#Main{
    display: flex;
    flex-direction: row;
    justify-content: space-between;  
}


/*Header*/
#Header { 
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    flex-wrap: wrap;
    align-items: flex-start;
    border-top-right-radius: 40px;
    background: linear-gradient(-45deg, #14386e , #003884, #0F5DA7, #2B77BF );
    background-size: 300% 100%;
    animation: gradient 10s ease infinite;
    box-shadow: 0 0 15px #2b77bf7e;
    padding-left: 20px;
    padding-right: 10px;
    min-height: 100vh;
}

/*header Gradiant Background Animation*/
@keyframes gradient {
    0% {
        background-position: 0% 50%;
    }
    50% {
        background-position: 100% 50%;
    }
    100% {
        background-position: 0% 50%;
    }
}

#Header #HeaderStart{
    display: flex;
    flex-direction: column;
}

#Header #CurrentPage{
    background-color: white;
    color: #085399;
    width: 88%;
    border-top-left-radius: 30px;
    border-bottom-left-radius: 30px;
    font-weight: bold;
}

#Header #CurrentPage:hover{
    filter: drop-shadow(0px 0px 5px #d5dee693);
    transform: translate3d(0, -2px, 0);
}

#Header #LogoLink{
    padding: 25px 30px 40px 10px;
}

#logo {
    max-width: 200px; 
    height: auto;
}

#Header a{
    color: white;
    padding: 15px 15px 15px 25px;
    font-size: 20px;
    text-decoration: none;
    transition: all .4s ease-in-out;
}

#Header a:hover{
    filter: drop-shadow(0px 0px 10px #d5dee693);
    transform: translate3d(0, -2px, 0);
}

#Header #LogoLink:hover{ /*Prevent logo hovering styeling*/
    filter: drop-shadow(0px 0px 0px #d5dee693);
    transform: translate3d(0, 0px, 0);
}


/*Social Media Icons*/
.social-icons{
    text-align: left;
    padding: 25px 15px ;
}

#Header .social-icons a{
    font-size:30px;
    margin: 0 -18px;
    text-decoration:none;
    transition: all .4s ease-in-out; 
}

#Header .social-icons a:hover i{
    transform: translate3d(0, -2px, 0);
}




/*Content*/
#Content{
    display: flex;
    flex-direction: column; 
    padding-top: 5.5vh;
    padding-bottom: 9.8vh;
    width: 85%;
}

#MenuButtons{
    display: flex;
    align-self: flex-end;
    padding-right: 30px;
}

#Bell {
    display: block;
    font-size:30px;
    font-weight: 300;
    padding: 7px 12px 5px 0px;
    color: #085399;
    transition: all .4s ease-in-out;
}

#Bell:hover{
    cursor: pointer;
}

#logoutButton {
    border: 0;
    border-radius: 30px;
    color: white;
    height: 40px;
    padding: 7px 56px;
    margin-bottom:  2vh;
    font-size: 16.5px;
    transition: all .4s ease-in-out;
    background: linear-gradient(-45deg, #2B77BF , #003884, #0F5DA7, #2B77BF );
    background-size: 100% 300%;   
}


#logoutButton:hover{
    box-shadow: 0 0 15px #2b77bf7e;
    color: white;
    transform: translate3d(0, -2px, 0);
    cursor: pointer;
}



/*Ofers Content*/
#Offers{
    display: flex;
    flex-direction: column;
    align-self: center;
    flex-wrap: wrap;
    width: 63vw;
    padding: 1vh 1vh;
    box-sizing: border-box;
}

#Offers h1{
    color: #085399;
    text-align: center;
    font-size: 35px;
    font-weight: 900;
    border-radius: 2px;
}

/*Navigation links*/
#links{
    display: flex;
    width: 100%;
    justify-content: center;
    margin-top: -10px;
    margin-bottom: 10px;
}

#link1{
    color: #085399;
    font-size: 20px;
    text-decoration: none;
}

#linksLine{
    width: 2px;
    background-color: #085399;
    border-radius: 50px;
    margin-left: 8px;
    margin-right: 8px;
    margin-bottom: 2px;
}

#link2{
    color: #085399;
    font-size: 20px;
    text-decoration: none;
}

#link1:hover, #link2:hover{
    color: #003884;
}


h2{
    color: #085399;
    padding-left: 20px;
    margin-bottom: 12px;
}

#WholeOffer{
    display: flex;
    justify-content: space-between;
    color: #085399;
    min-height: 27vh;
    height: auto;
    margin-bottom: 3vh;
    filter: drop-shadow(0px 2px 5px #d5dee693);
}

#FirstPart{
    display: flex;
    flex-direction: column;
    background-color: #085399;
    width: 26.6%;
    padding: 2vh 3vw;
    border-top-left-radius: 30px;
    border-bottom-left-radius: 30px;
    box-sizing: border-box;
}

#Title{
    text-transform: capitalize;
    text-align: left;
    font-size: 13px;
    letter-spacing: 1.5px;
    color: white;
    opacity: 0.7;
}

#JobTitle{
    text-transform: capitalize;
    text-align: left;
    font-size: 23px;
    margin-top: -4px;
    color: white;
    flex-grow: 1;
}

#FirstPart a{
    display: block;
    font-size: 13px;
    color: white;
    text-decoration: none;
    letter-spacing: 1.3px;
    color: white;
    opacity: 0.7;
}


#SecondPart{
    display: flex;
    flex-direction: column;
    width: 74.4%;
    padding: 2vh 3vw;
    background-color: white;   
    border-top-right-radius: 30px;
    border-bottom-right-radius: 30px;
    box-sizing: border-box;
}

#BottomDiv{
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: flex-start;
}

#PostDate{
    text-transform: capitalize;
    text-align: left;
    font-size: 13px;
    letter-spacing: 1.5px;
    color: #085399;
    opacity: 0.7;
}

#Status{
    text-transform: capitalize;
    text-align: left;
    font-size: 13px;
    letter-spacing: 1.5px;
    color: #085399;
    opacity: 0.7;
}

#Description{
    text-transform: capitalize;
    text-align: left;
    font-size: 13px;
    text-align: justify;
    line-height: 1.25;
    margin-top: 0px;
    color: #0c3a7b;
    flex-grow:1;
}

#CloseButton{
    border: 2px solid rgb(148, 6, 6);
    border-radius: 30px;
    background-color: transparent;
    color: rgb(148, 6, 6);
    padding: 5px 30px;
    font-size: 14px;
    margin-bottom: 8px;
    transition: all .4s ease-in-out;
    align-self: flex-end;
}


#CloseButton:hover{
    box-shadow: 0 0 10px rgba(158, 16, 16, 0.473);
    transform: translate3d(0, -2px, 0);
    cursor: pointer;
}

/*No offers message*/
#Empty{
    color: #024a8d;
    font-size: 3vh;
    text-align: center;
    margin-left: -10vh;
    margin-top: 35vh;
    margin-bottom: 9vh;
}

.tooltip {
    position: relative;
    display: inline-block;
}
  
.tooltip .tooltiptext {
    visibility: hidden;
    width: 190px;
    font-size: 13px;
    border: 2px solid rgb(188, 5, 5);
    color: rgb(188, 5, 5);
    text-align: center;
    border-radius: 6px;
    padding: 5px 5px;
    position: absolute;
    z-index: 1;
    top: 150%;
    left: 22%;
    margin-left: -60px;
}

.tooltip .tooltiptext::after {
    content: "";
    position: absolute;
    bottom: 100%;
    left: 50%;
    margin-left: -5px;
    border-width: 5px;
    border-style: solid;
    border-color: transparent transparent rgb(188, 5, 5) transparent;
}

.tooltip:hover .tooltiptext {
    visibility: visible;
}


/*Final Message*/
.modal_wrapper{
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	visibility: hidden;
    color: black;
}

.modal_wrapper .shadow{
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0,0,0,0.8);
	opacity: 0;
	transition: 0.2s ease;
}

.modal_wrapper .success_wrap{
	position: absolute;
	visibility: hidden;
	width: 30%;
	top: 50%;
	left: 50%;
	transform: translate(-50%,-800px);
	background:white;
	padding: 50px;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 5px;
	transition: 0.5s ease;
}


.modal_wrapper .faliure_wrap{
	position: absolute;
	visibility: hidden;
	width: 30%;
	top: 50%;
	left: 50%;
	transform: translate(-50%,-800px);
	background:white;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 5px;
	transition: 0.5s ease;
}

.modal_wrapper .success_wrap .modal_icon{
	margin-right: 20px;
	width: 50px;
	height: 50px;
	background: #4CBB17;
	color: white;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 32px;
	font-weight: 700;
}

.modal_wrapper.active{
	visibility: visible;
}

.success_wrap.active{
	visibility: visible;
	transform: translate(-50%,-50%);
}

.faliure_wrap.active{
	visibility: visible;
	transform: translate(-50%,-50%);
}

.modal_wrapper.active .shadow{
	opacity: 1;
}

.text_container {
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

#Confirmation{
    text-align: center;
    margin-top: 0;
    margin-bottom: 0;
    padding: 10px 30px;
}

#ConfirmationTitle{
    width: 100%;
    margin-bottom: 10px;
    margin-top: 0;
    background-color: rgb(188, 5, 5);
    border-top-left-radius:5px;
    border-top-right-radius: 5px;
    color: white;
    padding: 8px 30px;
    box-sizing: border-box;
}

.button_container {
    display: flex;
    justify-content: flex-end;
    margin-bottom:0 ;
    align-self: center;
    padding: 10px 30px 20px;
}


.confirm_button, .cancel_button{
	border: 0;
	padding: 9px 10px;
	background: rgb(188, 5, 5);
	color: white;
	width: 100px;
	justify-content: center;
	display: flex;
	align-items: center;
	font-size: 12px;
	border-radius: 5px;
	transition: 0.5s ease;
	cursor: pointer;
    letter-spacing:1px;
}


/*Form buttons*/
.cancel_button{
	background: #d4d4d4;
	transition: 0.5s ease;
    margin-right: 10px;
}


.confirm_button:hover{
	box-shadow: 0 0 15px rgba(188, 5, 5, 0.479);;
    transform: translate3d(0, -2px, 0);
}

.cancel_button:hover{
	box-shadow: 0 0 15px #8b8c8c6b;
    transform: translate3d(0, -2px, 0);
}

/*Notification*/
#NotificationCircle{
    position: absolute;
    top: 49px; 
    right: 214.5px;
    background-color: rgb(148, 6, 6);
    border-radius: 25px;
    width: 12px;
    height: 12px;
    z-index: 1;
    transition: all .4s ease-in-out;
}

#NotificationDiv{
    position: absolute;
    display: none;
    top: 95px; 
    right: 70px;
    width: 310px;
    height: 320px ; 
    background-color: white;
    box-shadow: 0 0 10px #d5dee6c6;
    z-index: 1; 
    border-radius: 8px;
    overflow-y: auto;
    padding-bottom: 5px;
    padding-top: 5px;
}

#NotificationTitle{
    padding: 9px;
    margin-top: 0;
    margin-bottom: 0;
    font-weight: 700;
    text-align: center;
    color: #085399;
}

#NotificationLine{
    background-color:#57575725;
    height: 0.5px;
    margin-left: 10px;
    margin-right: 10px;
}

#OneNotification{
    padding-left: 18px;
    padding-right: 18px;
    cursor: pointer;
}

#NotificationHeader{
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    color: #003884;
    padding-top: 4px;
    padding-bottom: 0px;
}

#CircleHeader{
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
}

#SeenCircle{
    height: 8px;
    width: 8px;
    background-color: #085399;
    border-radius: 25px;
    margin-right: 7px;
}

#UnseenCircle{
    height: 8px;
    width: 8px;
    background-color:rgb(148, 6, 6);
    border-radius: 25px;
    margin-right: 7px;
}

#SeenHeaderTitle{
    margin-top: 0;
    margin-bottom: 0;
    font-weight: 700;
    text-align: center;
    color: #085399;
    font-weight: lighter;
}

#UnseenHeaderTitle{
    margin-top: 0;
    margin-bottom: 0;
    font-weight: 700;
    text-align: center;
    color: rgb(148, 6, 6);
    font-weight: lighter;
}

#Notification{
    font-size: 15px;
    margin-top: -3px;
    color: #5757579d;
}

#Date{
    color: #5757579d;
    font-size: 13px;
    padding-right: 10px;
}

#NoNotification{
    color: #5757579d;
    text-align: center;
    margin-top: 105px;
}


/*Notification Scroller*/
.scrollbar
{
	margin-left: 30px;
	float: left;
	width: 65px;
	background: #F5F5F5;
	overflow-y: scroll;
	margin-bottom: 25px;
    border-top-right-radius: 10px;
    border-bottom-right-radius: 10px;
}

.style-4::-webkit-scrollbar-track
{
	-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
	background-color: #F5F5F5;
    border-top-right-radius: 10px;
    border-bottom-right-radius: 10px;
}

.style-4::-webkit-scrollbar
{
	width: 8px;
	background-color: #F5F5F5;
    border-top-right-radius: 10px;
    border-bottom-right-radius: 10px;
}

.style-4::-webkit-scrollbar-thumb
{
	background-color: #003884;
	border: 2px solid #555555;
    border-top-right-radius: 10px;
    border-bottom-right-radius: 10px;
}


#Edit{
    text-decoration: none;
    color: #085399;
    margin-top: 10px;
    margin-left: 28%;
    font-size: 20px;
}
.button-date-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
}


#CloseButton {
    margin-right: 10px;
}
