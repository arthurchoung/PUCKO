/*

 HOT DOG Linux

 Copyright (c) 2020 Arthur Choung. All rights reserved.

 Email: arthur -at- hotdoglinux.com

 This file is part of HOT DOG Linux.

 HOT DOG Linux is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.

 */

#import "HOTDOG.h"

#define MAX_RECT 640

static id _dialogText =
@"VOICE-OVER:A way out west there was this fella, fella I want to tell you about, fella by the name of Jeff Lebowski. At least, that was the handle his lovin' parents gave him, but he never had much use for it himself. This Lebowski, he called himself the Dude. Now, Dude, that's a name no one would self-apply where I come from. But then, there was a lot about the Dude that didn't make a whole lot of sense to me. And a lot about where he lived, like- wise. But then again, maybe that's why I found the place s'durned innarestin'.\n"
@"VOICE-OVER:They call Los Angeles the City of Angels. I didn't find it to be that exactly, but I'll allow as there are some nice folks there. 'Course, I can't say I seen London, and I never been to France, and I ain't never seen no queen in her damn undies as the fella says. But I'll tell you what, after seeing Los Angeles and thisahere story I'm about to unfold-- wal, I guess I seen somethin' ever' bit as stupefyin' as ya'd see in any a those other places, and in English too, so I can die with a smile on my face without feelin' like the good Lord gypped me.\n"
@"VOICE-OVER:Now this story I'm about to unfold took place back in the early nineties-- just about the time of our conflict with Sad'm and the Eye rackies. I only mention it 'cause some- times there's a man-- I won't say a hee-ro, 'cause what's a hee ro?--but sometimes there's a man ... and I'm talkin' about the Dude here-- sometimes there's a man, wal, he's the man for his time'n place, he fits right in there-- and that's the Dude, in Los Angeles... and even if he's a lazy man, and the Dude was certainly that--quite possibly the laziest in Los Angeles County.\n"
@"VOICE-OVER:...which would place him high in the runnin' for laziest worldwide- but sometimes there's a man... sometimes there's a man.\n"
@"VOICE-OVER:Wal...\n"
@"VOICE-OVER:Lost my train of thought here. But...\n"
@"VOICE-OVER:Aw hell, I done innerduced him enough.\n"
@"GEORGE BUSH:--- call for a collective action. This will not stand. This will not stand! This aggression against, uh, Kuwait.\n"
@"VOICE:Where's the money, Lebowski!\n"
@"VOICE:We want that money, Lebowski. Bunny said you were good for it.\n"
@"VOICE:Where's the money, Lebowski!\n"
@"VOICE:Where's the money, Lebowski!\n"
@"VOICE:WHERE'S THE FUCKING MONEY, SHITHEAD!\n"
@"DUDE:It's uh, it's down there somewhere. Lemme take another look.\n"
@"VOICE:Don't fuck with us.\n"
@"VOICE:Your wife owes money to Jackie Treehorn, that means you owe money to Jackie Treehorn.\n"
@"CHINESE MAN:Ever thus to deadbeats, Lebowski.\n"
@"DUDE:Oh, no. Don't do that. Not on the rug, man.\n"
@"BLOND MAN:See, You see what happens, Lebowski? You see what happens?\n"
@"DUDE:Nobody calls me Lebowski. You got the wrong guy. I'm the Dude, man.\n"
@"BLOND MAN:Your name is Lebowski, Lebowski. Your wife is Bunny.\n"
@"DUDE:Muh muh Wi-- my wife? Bunny?\n"
@"DUDE:You see a wedding ring on my finger? Does this place look like I'm fucking married? The toilet seat's up man!\n"
@"BLOND MAN:What the fuck is this?\n"
@"DUDE:Obviously you're not a golfer.\n"
@"BLOND MAN:Woo?\n"
@"WOO:Yeah?\n"
@"BLOND MAN:Isn't this guy supposed to be a millionaire?\n"
@"WOO:Fuck.\n"
@"BLOND MAN:Yeah, what do you think?\n"
@"WOO:He looks like a fuckin' loser.\n"
@"DUDE:Hey. At least I'm housebroken.\n"
@"WOO:Fuckin' time waste.\n"
@"BLOND MAN:Thanks a lot, asshole.\n"
@"MAN:Wahooo, I'm throwin' rocks tonight. Mark it, Dude.\n"
@"WALTER:This was a valued rug.\n"
@"WALTER:This was, uh--\n"
@"DUDE:Yeah man, it really tied the room together--\n"
@"WALTER:This was a valued, uh.\n"
@"DUDE:Yeah...\n"
@"DONNY:What tied the room together, Dude?\n"
@"DUDE:My rug.\n"
@"WALTER:Were you listening to the story, Donny?\n"
@"DONNY:What?\n"
@"DUDE:Walter..\n"
@"WALTER:Were you listening to the Dude's story?\n"
@"DONNY:I was bowling--\n"
@"WALTER:So you have no frame of reference, here Donny. You're like a child who wanders in -\n"
@"DUDE:Walter...\n"
@"WALTER:- in the middle of a movie and wants to--\n"
@"DUDE:Walter, walter, what's the point man?\n"
@"WALTER:There's no fucking reason--here's my point, Dude--there's no fucking reason why these --\n"
@"DONNY:Yeah Walter, what's your point?\n"
@"WALTER:Huh?\n"
@"DUDE:Walter, what's the point. Look--we all know who was at fault here, what the fuck are you talking about?\n"
@"WALTER:Huh? No! What the fuck are you - I'm not--we're talking about unchecked aggression here, Dude.\n"
@"DONNY:What the fuck is he talking about?\n"
@"DUDE:My rug.\n"
@"WALTER:Forget it, Donny. You're out of your element.\n"
@"DUDE:Walter, the Chinaman who peed on my rug, I can't go give him a bill, so what the fuck are you talking about?\n"
@"WALTER:What the fuck are you talking about?! The Chinaman is not the issue here dude! I'm talking about drawing a line in the sand, Dude. Across this line you do not,-- also, Dude, Chinaman is not the preferred nomenclature, uh, Asian American, Please.\n"
@"DUDE:Walter, this isn't a guy who built the rail- roads, here, this is a guy --\n"
@"WALTER:What the fuck are you talk--\n"
@"DUDE:Walter, he peed on my rug.\n"
@"DONNY:He peed on the Dude's rug.\n"
@"WALTER:DONNIE YOU'RE OUT OF YOUR ELEMENT! Dude the Chinaman is not the issue here.\n"
@"DUDE:So who, who--\n"
@"WALTER:Jeff Lebowski. The other Jeffrey Lebowski. The millionaire.\n"
@"DUDE:That's fucking interesting man, that's fucking interesting...\n"
@"WALTER:Plus, he has the wealth, obviously, and the resources, uh, so that there is no reason, there's no FUCKING reason, why his wife should go out and owe money all over town, and then they come and they pee on your fucking rug! Am I wrong?\n"
@"DUDE:No...\n"
@"WALTER:Am I wrong!\n"
@"DUDE:Yeah, but--\n"
@"WALTER:Okay then. uh,\n"
@"WALTER:That rug really tied the room together, did it not?\n"
@"DUDE:Fuckin' A.\n"
@"DONNY:And this guy peed on it.\n"
@"WALTER:Donny, Please.\n"
@"DUDE:You know, this is the fuckin' guy... I could find this Lebowski guy.\n"
@"DONNY:His name is Lebowski? That's your name, Dude!\n"
@"DUDE:This is the guy, who should compensate me for the fucking rug. His wife goes out and owes money all over town, and they pee on my rug?\n"
@"WALTER:They pee on your fucking Rug?\n"
@"DUDE:They peed on my fucking rug.\n"
@"WALTER:Thaaat's right Dude; they peed on your fucking Rug.\n"
@"YOUNG MAN:This is the study. As you can see the various commendations, awards--\n"
@"DUDE:Jeffery Lebowski...\n"
@"YOUNG MAN:--citations, honorary degrees, et cetera.\n"
@"DUDE:Hmm, very impressive.\n"
@"YOUNG MAN:Please, feel free to inspect them.\n"
@"DUDE:Hum? Oh, I'm not that-- really, uh.\n"
@"YOUNG MAN:Oh, Please! Please!\n"
@"YOUNG MAN:That's the key to the city of Pasadena, which Mr. Lebowski received two years ago in recognition of his various civic, uh... Oh, That's a Los Angeles Chamber of Commerce Business Achiever award, which is given--oh not necessarily given every year!\n"
@"DUDE:Hey, is this uh..?\n"
@"YOUNG MAN:Given only when there's a worthy--\n"
@"DUDE:is this ...?\n"
@"YOUNG MAN:--somebody--\n"
@"DUDE:Is this him with Nancy?\n"
@"YOUNG MAN:Yes indeed, that is Mr. Lebowski with the First Lady, yes. It was taken when Mrs. Reagan--\n"
@"DUDE:That's uh, Lebowski on the left there?\n"
@"YOUNG MAN:Yeah. Of course, Mr. Lebowski on the left...\n"
@"DUDE:So he's a crip...you know a, a...\n"
@"YOUNG MAN:uh, ahmmm...\n"
@"DUDE:Handicapped, kinda guy?\n"
@"YOUNG MAN:Mr. Lebowski is disabled, yes. This picture was taken when Mrs. Reagan was first lady of the nation, yes, yes? Not of California.\n"
@"DUDE:Chuck.\n"
@"YOUNG MAN:In fact he met privately with the President, though unfortunately there wasn't time for a photo opportunity.\n"
@"DUDE:Oh, Nancy's pretty good.\n"
@"YOUNG MAN:Oh, Wonderful woman. We were very happy to--\n"
@"DUDE:Uh...these are, uh?\n"
@"YOUNG MAN:Uh those are Mr. Lebowski's children, so to speak--\n"
@"DUDE:Different mothers, huh?\n"
@"YOUNG MAN:No, they're not--\n"
@"DUDE:So, racially he's pretty cool--\n"
@"YOUNG MAN:Aha ha ha uh, they're not literally his children; they're the Little Lebowski Urban Achievers, inner city children of promise but without the necessary means for a necessary means, for a higher education, so Mr. Lebowski has committed to sending all of them to college.\n"
@"YOUNG MAN:Excuse me. Thank you, thank you.\n"
@"DUDE:Far out. Think he's got room for one more?\n"
@"YOUNG MAN:One uh--oh! Heh-heh. You never went to college.\n"
@"YOUNG MAN:Please, uh, don't touch that.\n"
@"DUDE:Oh yeah, yeah, no I did, but uh, You know I spent most of my time uh, occupying various, administration buildings uh--\n"
@"YOUNG MAN:Um Hmmm.\n"
@"DUDE:--smoking a lot of thai-stick, breaking into the ROTC--\n"
@"YOUNG MAN:Aha hahahahahaha Yes, --\n"
@"DUDE:--and bowling. I'll tell you the truth, Brandt, I don't remember most of it.\n"
@"DUDE:Hmmm.\n"
@"LEBOWSKI:Okay sir, you're a Lebowski, I'm a Lebowski, that's terrific, but I'm very busy, as I can imagine you are. What can I do for you sir?\n"
@"DUDE:Uh, well sir, it's, uh, this rug I have, it really tied the room together-uh--\n"
@"LEBOWSKI:You told Brandt on the phone, he told me. Where do I fit in?\n"
@"DUDE:Well, uh, they were--they were looking for you, these two guys, uh you know they--\n"
@"LEBOWSKI:I'll say it again, you told Brandt on the phone. He told me. I know what happened. Yes? Yes?\n"
@"DUDE:Oh, so you know they were trying to piss on your rug?\n"
@"LEBOWSKI:Did I urinate on your rug?\n"
@"DUDE:You mean, did you personally come and pee on my rug?\n"
@"LEBOWSKI:Hello! Do you speak English son? Parla usted Inglese? I'll say it again. Did I urinate on your rug?\n"
@"DUDE:No, like I said, Woo, peed on my rug.\n"
@"LEBOWSKI:I just want to understand this sir, every time a rug is micturated upon in this fair city, I have to compensate the person?\n"
@"DUDE:Come on, man, I'm not trying to scam anybody here, uh, you know, I'm just--uh...\n"
@"LEBOWSKI:You're just looking for a handout like every other--are you employed, Mr. Lebowski?\n"
@"DUDE:Huh? wait wait, let me, let me explain something to you. Uh, I am not Mr. Lebowski; you're Mr. Lebowski. I'm the Dude. So that's what you call me. You know, uh, That, or uh, his Dudeness, or uh Duder, or uh El Duderino, if, you know, you're not into the whole brevity thing--uh.\n"
@"LEBOWSKI:Are you employed, sir?\n"
@"DUDE:Employed? ah ha...\n"
@"LEBOWSKI:You don't go out looking for a job dressed like that do ya? On a weekday?\n"
@"DUDE:Is this a--what day is this?\n"
@"LEBOWSKI:Well I do work sir, so if you don't mind--\n"
@"DUDE:Yeah, I do mind. The Dude minds. This will not stand, ya know, this aggression will not stand, man. I mean, your wife owes money--\n"
@"LEBOWSKI:My wife, is not the issue here! I hope that someday my wife will learn to live on her allowance, which is ample, but if she does not, that is her problem, not mine, just as your rug is your problem, just as\n"
@"LEBOWSKI:every bum's lot in life is his own responsibility regardless of whom he chooses to blame. I didn't blame anyone for the loss of my legs, some chinaman took them from me in Korea but I went out and achieved anyway. I cannot solve your problems, sir, only you can.\n"
@"DUDE:Ah fuck it.\n"
@"LEBOWSKI:Oh, \"Fuck it!\" Yes, that's your answer! That's your answer to everything! Tattoo it on your forehead!\n"
@"LEBOWSKI:Your \"revolution\" is over, Mr. Lebowski! Condolences! The bums lost!\n"
@"LEBOWSKI:My advice to you is, to do what your parents did! Get a job, sir! The bums will always lose-- do you hear me, Lebowski?\n"
@"LEBOWSKI:...THE BUMS WILL ALWAYS LOSE!\n"
@"BRANDT:How was your meeting, Mr. Lebowski?\n"
@"DUDE:Okay. The old man told me to take any rug in the house.\n"
@"BRANDT:Well, enjoy, and perhaps we'll see you again some time, Dude.\n"
@"DUDE:Yeah sure, uh,\n"
@"DUDE:...if I'm in the neighborhood, you know, and uh, I need to use the john.\n"
@"YOUNG WOMAN:Blow on them.\n"
@"DUDE:Huh?\n"
@"YOUNG WOMAN:G'ahead. Blow.\n"
@"DUDE:You want me to blow on your uh, toes?\n"
@"YOUNG WOMAN:Uh-huh, heh heh . . I can't blow that far.\n"
@"DUDE:You sure he won't mind?\n"
@"YOUNG WOMAN:Uli doesn't care about anything. He's a nihilist.\n"
@"DUDE:Ah, that must be exhausting.\n"
@"YOUNG WOMAN:You're not blowing.\n"
@"BRANDT:Our guest has to be getting along, Mrs. Lebowski.\n"
@"DUDE:Ahhh, you're Bunny.\n"
@"BUNNY:I'll suck your cock for a thousand dollars.\n"
@"BRANDT:Ha-ha-ha-ha! Wonderful woman. We're all very fond of her. Very free spirited.\n"
@"BUNNY:Brandt can't watch though. Or he has to pay a hundred.\n"
@"BRANDT:Aha-ha-ha-ha! That's marvelous.\n"
@"DUDE:Uhhhh...I'm just gonna go find a cash machine.\n"
@"THE BOWLERS:Donny backs away from the line, turns and walks back.\n"
@"DONNY:Wahooo...I'm slammin' 'em tonight You guys are dead in the water!!\n"
@"WALTER:Alright! Way to go, Donny! If you will it, it is no dream.\n"
@"DUDE:You're fucking twenty minutes late, man. What the fuck is that?\n"
@"WALTER:Theodore Herzel.\n"
@"DUDE:Huh?\n"
@"WALTER:State of Israel. If you will it, Dude, it is no dream.\n"
@"DUDE:What the fuck're you talking about man? The carrier. What's in the fucking carrier?\n"
@"WALTER:Huh? Oh!--Cynthia's dog. I think it's a Pomeranian. I can't leave him home alone or he eats the furniture. I'm watching it while Cynthia and Marty Ackerman are in Hawaii.\n"
@"DUDE:You brought a fucking Pomeranian bowling?\n"
@"WALTER:What do you mean \"brought it bowling\"? I didn't rent it shoes. I'm not buying it a fucking beer. He's not taking your fucking turn, Dude.\n"
@"DUDE:Man, if my fucking ex-wife asked me to take care of her fucking dog while she and her boyfriend went to Honolulu, I'd tell her to go fuck herself. Why can't she board it?\n"
@"WALTER:First of all, Dude, you don't have an ex, secondly, this is a fucking show dog with fucking papers. You can't board it. It gets upset, its hair falls out.\n"
@"DUDE:Hey man, Walter, you know--\n"
@"WALTER:Fucking dog has fucking papers- Over the line!\n"
@"SMOKEY:Huh?\n"
@"WALTER:I'm sorry Smokey, You were over the line, that's a foul.\n"
@"SMOKEY:Bullshit. Mark it eight Dude.\n"
@"WALTER:Excuse me! Mark it zero. Next frame.\n"
@"SMOKEY:Bullshit. Walter! Mark it eight Dude.\n"
@"WALTER:Smokey, this is not Nam. This is bowling. There are rules.\n"
@"DUDE:Hey Walter come on, it's just--hey man it's Smokey. So his toe slipped over a little, you know, it's just a game, man.\n"
@"WALTER:This is a league game. This determines who enters the next round-robin, am I wrong?\n"
@"SMOKEY:Yeah, but I wasn't--\n"
@"WALTER:Am I wrong!?\n"
@"SMOKEY:Yeah, but I wasn't over. Gimme the marker, Dude, I'm marking it an eight.\n"
@"WALTER:Smokey my friend, you're entering a world of pain.\n"
@"DUDE:Walter--man--\n"
@"WALTER:You mark that frame an eight, you're entering a world of pain.\n"
@"SMOKEY:I'm not--\n"
@"WALTER:A world of pain.\n"
@"SMOKEY:Look Dude, I ... this is your partner--\n"
@"WALTER:HAS THE WHOLE WORLD GONE CRAZY? AM I THE ONLY ONE HERE WHO GIVES A SHIT ABOUT THE RULES? MARK IT ZERO!\n"
@"DUDE:They're calling the cops, man, put the piece away.\n"
@"WALTER:MARK IT ZERO!\n"
@"DUDE:Walter put the piece away.\n"
@"SMOKEY:Walter--\n"
@"WALTER:YOU THINK I'M FUCKING AROUND HERE?\n"
@"WALTER:MARK IT ZERO!!\n"
@"SMOKEY:All right!! It's fucking zero! You happy, you crazy fuck?\n"
@"WALTER:It's a league game, Smokey!\n"
@"DUDE:You can't do that man. These guys, you know, they're like me, they're pacificists. Smokey was a conscientious objector.\n"
@"WALTER:You know Dude, I myself dabbled with pacifism at one point. Not in Nam, of course--\n"
@"DUDE:And you know he's got emotional problems man!\n"
@"WALTER:You mean--beyond pacifism?\n"
@"DUDE:He's fragile, very fragile!\n"
@"WALTER:Huh. I did not know that. Well, it's all water under the bridge. And we do enter the next round robin, am I wrong?\n"
@"DUDE:No, you're not wrong--\n"
@"WALTER:Am I wrong!\n"
@"DUDE:You're not wrong, Walter, you're just an asshole.\n"
@"WALTER:Okay then. We play Quintana and O'Brien next week. They should be pushovers.\n"
@"DUDE:Man, willya just, just take it easy, man.\n"
@"WALTER:You know, that's your answer for everything, Dude. And let me point out something--pacifism is not- look at our current situation with that camelfucker in Iraq-- pacifism is not something to hide behind.\n"
@"DUDE:Just take it easy, man.\n"
@"WALTER:I'm perfectly calm, Dude.\n"
@"DUDE:Yeah? Wavin' the fuckin' gun around?!\n"
@"WALTER:Calmer than you are.\n"
@"DUDE:Will you just take it easy?\n"
@"WALTER:Calmer than you are.\n"
@"VOICE:Dude, this is Smokey. Look, I don't wanna be a hard-on about this, and I know it wasn't your fault, but I just thought it was fair to tell you that Gilbert and I will be submitting this to the League and asking them to set aside the round, I don't know, or maybe, forfeit it to us-- so, like I say, just thought, you know, fair warning. Tell Walter. I'm sorry.\n"
@"ANOTHER VOICE:Mr. Lebowski, this is Brandt at, uh, well--at Mr. Lebowski's office. Please call us as soon as is convenient.\n"
@"ANOTHER VOICE:Mr. Lebowski, this is Bell Salnicker with the Southern Cal Bowling League, and I just got a, an informal report, that a member of your team, uh, Walter Sobchak, drew a firearm during league play. If this is true of course, it contraviens a number of the league's by-laws, and article 27 of the league...\n"
@"MAN:Dude.\n"
@"DUDE:Hey Marty.\n"
@"MARTY:Dude, I, I finally, I got the uh, venue I wanted. Uh, I'm Performing my dance quintet--you know, my cycle--at Crane Jackson's Fountain Street Theatre on Tuesday night, and well I'd love it if you came and gave me notes.\n"
@"DUDE:I'll be there man.\n"
@"MARTY:Uh, Dude, uh, tomorrow's already the tenth.\n"
@"DUDE:Far out. Oh, oh, alright, okay.\n"
@"MARTY:Just, uh, just slip the rent under my door.\n"
@"VOICE:--serious infraction, and examine your standing. Thank you.\n"
@"VOICE:Mr. Lebowski, Brandt again. Please do call us as soon as you get in and I'll send the limo. I hope you're not avoiding this call because of the rug, ha ha, which, I assure you, is not a problem. We need your help and, uh--well we would very much like to see you. Thank you. It's Brandt.\n"
@"BRANDT:We've had some terrible news. Mr. Lebowski is in seclusion in the West Wing.\n"
@"BRANDT:Mr. Lebowski.\n"
@"LEBOWSKI:Funny-- I can look back on a life of achievement, on challenges met, competitors bested, obstacles overcome. I've accomplished more than most men, and without the use of my legs. What. . . What makes a man, Mr. Lebowski?\n"
@"DUDE:Dude.\n"
@"LEBOWSKI:Huh?\n"
@"DUDE:Uh, I, I don't know, sir.\n"
@"LEBOWSKI:Is it being prepared to do the right thing? Whatever the cost? Isn't that what makes a man?\n"
@"DUDE:Ummm..sure. That and a pair of testicles.\n"
@"LEBOWSKI:You're joking. But perhaps you're right.\n"
@"DUDE:You mind if I do a jay?\n"
@"LEBOWSKI:Bunny.\n"
@"DUDE:'Scuse me?\n"
@"LEBOWSKI:Bunny Lebowski... She is the light of my life. Are you surprised at my tears, sir?\n"
@"DUDE:Oh, fuckin' A.\n"
@"LEBOWSKI:Strong men also cry... Strong men also cry.\n"
@"LEBOWSKI:I received this fax this morning.\n"
@"LEBOWSKI:As you can see, it is a ransom note.\n"
@"LEBOWSKI:Written by men who are unable to achieve on a level field of play.\n"
@"LEBOWSKI:Cowards!\n"
@"LEBOWSKI:Weaklings.\n"
@"LEBOWSKI:Bums.\n"
@"DUDE:Bummer.\n"
@"LEBOWSKI:Huh?\n"
@"DUDE:This is a bummer man. That's a, that's a bummer.\n"
@"LEBOWSKI:Brandt will fill you in on the details.\n"
@"BRANDT:Mr. Lebowski is prepared to make a generous offer to you to act as courier once we get instructions for the money.\n"
@"DUDE:Why me, man?\n"
@"BRANDT:He believes that the culprits might be the very people who, uh, soiled your rug, and you're in a unique position to confirm or, disconfirm that suspicion.\n"
@"DUDE:He thinks the carpet-pissers did this?\n"
@"BRANDT:Well Dude, we just don't know.\n"
@"QUINTANA:Wheeling and thrusting a black gloved single finger into the air.\n"
@"DUDE:Fucking Quintana--that creep can roll, man--\n"
@"WALTER:Yeah, but he's a fucking pervert, Dude.\n"
@"DUDE:Yeah?\n"
@"WALTER:No. He's a sex offender. With a record. He did six months in Chino for exposing himself to an eight- year-old.\n"
@"DUDE:Huh.\n"
@"WALTER:When he moved down to Hollywood he had to go door-to-door to tell everyone he was a pederast.\n"
@"DONNY:What's a pederast, Walter?\n"
@"WALTER:Shut the fuck up, Donny.\n"
@"WALTER:So. How much they give you?\n"
@"DUDE:Twenty grand, man. And of course I still keep the rug.\n"
@"WALTER:Just for making the hand-off?\n"
@"DUDE:Yeah.\n"
@"DUDE:...They gave uh, Dude a beeper, so whenever these guys call--\n"
@"WALTER:What if it's during a game?\n"
@"DUDE:Oh, I told him if it was during league play--\n"
@"DONNY:What's during league play?\n"
@"DUDE:Uh, ya know...\n"
@"WALTER:Life does not stop and start at your convenience --\n"
@"DUDE:I uh...\n"
@"WALTER:--you miserable piece of shit.\n"
@"DUDE:I, I figure uh,\n"
@"DONNY:What's wrong with Walter, Dude?\n"
@"DUDE:I figure it's easy money, ya know, it's all pretty harmless. She probably kidnapped herself.\n"
@"WALTER:Huh?\n"
@"DUDE:Aww...\n"
@"DONNY:What do you mean, Dude?\n"
@"DUDE:Rug-peers did not do this. Look at it. Young trophy wife. Marries this guy for money, she figures he isn't giving her enough. Ya know, She owes money all over town-- aww.\n"
@"WALTER:That...fucking...bitch!\n"
@"DUDE:It's all a goddamn fake man. It's like Leninsaid, you look for the person who will benefit. And uh,uh, you know, uh...\n"
@"DONNIE:I am the Walrus.\n"
@"DUDE:...you know... you'll, uh, uh, you know what I'm trying to say--\n"
@"DONNY:I am the Walrus.\n"
@"WALTER:That fucking bitch!\n"
@"DUDE:Yeah.\n"
@"DONNY:I am the Walrus.\n"
@"WALTER:That's ex-- Shut the fuck up, Donny! V.I. Lenin! Vladimir Ilyich Ulyanov!\n"
@"DONNY:What the fuck is he talking about?\n"
@"WALTER:Fucking exactly what happened. Those--\n"
@"DUDE:Hell yeah.\n"
@"WALTER:That makes me fucking SICK!\n"
@"DUDE:Well, what do you care, Walter?\n"
@"WALTER:Those rich fucks! This whole fucking thing-- I did not watch my buddies die face down in the muck so that this fucking strumpet--\n"
@"DUDE:Walter--\n"
@"WALTER:This fuckin' whore...\n"
@"DUDE:I don't see any--\n"
@"WALTER:...can waltz around town...\n"
@"DUDE:--connection with Vietnam, man.\n"
@"WALTER:Well, there isn't a literal connection, Dude.\n"
@"DUDE:Walter, face it, there isn't any connection. Your roll.\n"
@"WALTER:Have it your way, but my point is--\n"
@"DUDE:Your roll--\n"
@"WALTER:My point is--\n"
@"DUDE:Your roll.\n"
@"VOICE:Are you ready to be fucked, man?\n"
@"QUINTANA:I see you rolled your way into the semis. Dios mio, man. Liam and me, we're gonna fuck you up.\n"
@"DUDE:Yeah well, ya know, that's just, like uh, your opinion, man.\n"
@"QUINTANA:Let me tell you something, pendejo. You pull any your crazy shit with us, you flash a piece out on the lanes, I'll take it away from you and stick it up your ass and pull the fucking trigger till it goes \"click\".\n"
@"DUDE:Jesus.\n"
@"QUINTANA:You said it, man. Nobody fucks with the Jesus.\n"
@"WALTER:Eight-year-olds, Dude.\n"
@"DUDE:Aaaah...Oh man. Ohhhh...Awwww...\n"
@"BRANDT:They called about eighty minutes ago. They want you to take the money and drive north on the 405. They will call you on the portable phone with instructions in about forty minutes. One person only, they were very clear on that, or I'd go with you. One person only. What happened to your jaw?\n"
@"DUDE:Oh, nothin', man just ah--\n"
@"BRANDT:Here's the money...\n"
@"BRANDT:and the phone...\n"
@"BRANDT:Please, Dude, follow whatever instructions they give.\n"
@"DUDE:Alright.\n"
@"BRANDT:Her life is in your hands.\n"
@"DUDE:Oh, man, don't say that man.\n"
@"BRANDT:Mr. Lebowski asked me to repeat that: Her life is in your hands.\n"
@"DUDE:Oh shit, man.\n"
@"BRANDT:Her life is in your hands, Dude. And report back to us as soon as it's done.\n"
@"DUDE:Where the fuck are you going, man?\n"
@"WALTER:Take the ringer. I'll drive.\n"
@"DUDE:The what?\n"
@"WALTER:The ringer! The ringer, Dude!\n"
@"DUDE:What the...\n"
@"WALTER:Have they called yet?\n"
@"DUDE:What the hell is this?\n"
@"WALTER:My dirty undies dude. Laundry, The whites.\n"
@"DUDE:Walter, I'm sure there's a reason you brought your dirty undies man.\n"
@"WALTER:Thaaaat's right, Dude. The weight. The ringer can't look empty.\n"
@"DUDE:Walter--what the fuck are you thinking man?\n"
@"WALTER:Well you're right, Dude, I got to thinking. I got to thinking why should we settle for a measly fucking twenty grand--\n"
@"DUDE:We? What the fuck we? You said you just wanted to come along--\n"
@"WALTER:My point, Dude, is why should we settle for twenty grand when we can keep the entire million. Am I wrong?\n"
@"DUDE:Yes you're wrong. This isn't a fucking game man.\n"
@"WALTER:Oh, but it is a game. You said so yourself. She kidnapped herself.\n"
@"DUDE:I said I thought--\n"
@"DUDE:Dude here.\n"
@"VOICE:Who is this?\n"
@"DUDE:Dude the Bagman. Where do you want us to go?\n"
@"VOICE:Us?\n"
@"DUDE:Shit. . . yeah, you know, uh, me and the driver. I'm not uh, handling the money and driving the car and talking on the phone all by my fucking--\n"
@"VOICE:Shut the fuck up.\n"
@"WALTER:Dude, are you fucking this up?\n"
@"VOICE:Who is that?\n"
@"DUDE:That is the driver, I told you--\n"
@"DUDE:Oh shit.\n"
@"WALTER:What the fuck's going on?\n"
@"DUDE:Walter!\n"
@"WALTER:What the fuck is going on?\n"
@"DUDE:He hung up, man! You fucked it up! You fucked it up! Her life was in our hands man!\n"
@"WALTER:Easy, Dude.\n"
@"DUDE:We're screwed now! We don't get shit, they're gonna kill her! We're fucked, Walter!\n"
@"WALTER:Nothing is fucked Dude. Come on. You're being very unDude. They'll call back. Look, she kidnapped her--\n"
@"WALTER:Ya see? Nothing's fucked here, Dude. Nothing is fucked. They're a bunch of fucking amateurs--\n"
@"DUDE:But Walter, Walter will you just shut the fuck up! Don't say peep when I'm doing business here man.\n"
@"WALTER:Okay Dude. Have it your way.\n"
@"WALTER:But they're amateurs.\n"
@"DUDE:Dude.\n"
@"VOICE:Okay, vee proceed. But only if there is no funny stuff.\n"
@"DUDE:Yeah, yeah.\n"
@"VOICE:So no funny stuff. Okay?\n"
@"DUDE:Just tell me where the fuck you want us to go.\n"
@"DUDE:That was the sign man.\n"
@"WALTER:So, all we gotta do is get her back, no one's in a position to complain, and we keep the baksheesh.\n"
@"DUDE:Yeah, terrific, Walter. But you haven't told me how we're gonna get her back. Where is she?\n"
@"WALTER:That's the simple part, Dude. We make the handoff, I grab one of 'em and beat it out of him.\n"
@"WALTER:...Huh?\n"
@"DUDE:Yeah. That's a great plan, Walter. That's fucking ingenious, if I understand it correctly. That's a Swiss fucking watch.\n"
@"WALTER:Thaaat's right, Dude. The beauty of this is its simplicity. Once a plan gets too complex, everything can go wrong. If there's one thing I learned in Nam--\n"
@"DUDE:Dude.\n"
@"VOICE:You are coming to a vooden bridge. When you cross the bridge you srow ze bag from ze left vindow of ze moving kar. You're being vatched.\n"
@"DUDE:FUCK.\n"
@"WALTER:What'd he say? Where's the hand off?\n"
@"DUDE:There is no fucking hand-off man. At a wooden bridge we throw the money out of the car!\n"
@"WALTER:Huh?\n"
@"DUDE:We throw the money out of the moving car!\n"
@"WALTER:No, we can't do that, Dude. That fucks up our plan.\n"
@"DUDE:Well call them up and explain it to 'em, Walter! Your plan is so fucking simple, I'm sure they'll fucking understand it! That's the beauty of it!\n"
@"WALTER:Wooden bridge, huh?\n"
@"DUDE:I'm throwing the money, Walter! We're not fucking around man!\n"
@"WALTER:Ok, dude the bridge is coming up! Gimme the ringer, Chop-chop!\n"
@"DUDE:Fuck that! Walter I love you, but sooner or later you're gonna have to face the fact that you're a goddamn moron.\n"
@"WALTER:Okay, Dude. No time to argue.\n"
@"DUDE:Hey man! hey--\n"
@"WALTER:Here's the bridge--\n"
@"DUDE:Walter! hey--hey walter hey--\n"
@"WALTER:There goes the ringer.\n"
@"DUDE:What the fuck!\n"
@"WALTER:Okay Dude, your wheel!\n"
@"DUDE:Walter Hey, Hey what the fuck?\n"
@"WALTER:At fifteen em-pee-aitch I roll out! I double back, grab one of 'em and beat it out of him! The uzi!\n"
@"DUDE:Uzi?\n"
@"WALTER:You didn't think I was rolling out of here naked did ya!\n"
@"DUDE:Walter, Walter what the--\n"
@"WALTER:Fifteen! Dude This is it! Let's take that hill!\n"
@"DUDE:Walter hey Walter--\n"
@"DUDE:Ah, ahhhh...\n"
@"DUDE:WE HAVE IT! WE HAVE IT!! WE HAVE IT!... WE...have it.\n"
@"WALTER:Ahh fuck it dude, let's go bowling.\n"
@"WALTER:Aitz chaim he, Dude. As the ex used to say.\n"
@"DUDE:What the fuck is that supposed to mean? What the fuck're we gonna tell Lebowski?\n"
@"WALTER:Huh? Oh, him, uh, I don't kn.. um-- what exactly is the problem?\n"
@"DUDE:Ah, the problem is--what do you mean what's the--\n"
@"DUDE:There was no--we didn't uh-- they're gonna kill that poor woman man.\n"
@"WALTER:What the fuck're you talking about? That poor woman--that poor slut-- kidnapped herself, Com'on Dude. You said so yourself.\n"
@"DUDE:Man! I said I thought she kidnapped herself! You're the one who's so fucking certain--\n"
@"WALTER:That's right, Dude, 100% certain--\n"
@"DONNY:They posted the next round of the tournament--\n"
@"WALTER:Donny, shut the fu--when do we play?\n"
@"DONNY:This Saturday. Quintana and--\n"
@"WALTER:Saturday! Well they'll have to reschedule.\n"
@"DUDE:Walter, what'm I gonna tell Lebowski?\n"
@"WALTER:I told that fuck down at the league office-- who's in charge of scheduling?\n"
@"DUDE:Walter--\n"
@"DONNY:Burkhalter.\n"
@"WALTER:I told that kraut a fucking thousand times I DON'T ROLL ON SHABBAS!\n"
@"DUDE:Walter--\n"
@"DONNY:He already posted it.\n"
@"WALTER:WELL THEY CAN FUCKING UN-POST IT!\n"
@"DUDE:WHO GIVES A SHIT! Uh, they're gonna kill that poor woman, man. What am I gonna tell Lebowski?\n"
@"WALTER:C'mon Dude, uh, eventually she'll get sick of her little game and, you know, wander on back--\n"
@"DUDE:Yeah uh...\n"
@"DONNY:How come you don't roll on Saturday, Walter?\n"
@"WALTER:I'm shomer shabbos.\n"
@"DONNY:What's that, Walter?\n"
@"DUDE:Yeah, and in the meantime, what do I tell Lebowski?\n"
@"WALTER:Saturday, Donny, is shabbos. The Jewish day of rest. That means I don't work, I um, don't drive a car, I don't fucking ride in a car, I don't handle money, I don't turn on the oven, and I sure as shit DON'T FUCKING ROLL!\n"
@"DONNY:Sheesh.\n"
@"WALTER:SHOMER SHABBAS!\n"
@"DUDE:Walter, how am I going to--hows--\n"
@"WALTER:Shomer fucking shabbas!\n"
@"DUDE:Oh fuck, that, that's it. I'm out of here.\n"
@"WALTER:Aw come on Dude.\n"
@"WALTER:Dude! Dude! ... ow, fuck, you just tell him, uh tell him we made the drop and everything went, uh you know--\n"
@"DONNY:Oh yeah, how'd it go?\n"
@"WALTER:Went alright. Dude's car got a little dinged up--\n"
@"DUDE:Walter, we didn't make the fucking hand-off man! They didn't get, the fucking money and they're gonna-- they're gonna--\n"
@"WALTER:\"They're gonna kill that poor woman.\"\n"
@"WALTER:They're gonna kill that poor woman.\n"
@"DONNY:Hey Walter, if you can't ride in a car, how d'you get around on Shammas--\n"
@"WALTER:Really, Dude, you surprise me. They're not gonna kill shit. They're not gonna do shit. What can they do? They're a bunch of fuckin' amateurs. And meanwhile, look at the bottom line. Who's sitting on a million fucking dollars? Am I wrong?\n"
@"DUDE:Walter--\n"
@"WALTER:Who's got a fucking million fucking dollars sittin' in the trunk of our car?\n"
@"DUDE:\"Our\" car, Walter?\n"
@"WALTER:And what do they got? My dirty undies. My fucking whites---Say, Dude, where is your car?\n"
@"DONNY:Who's got your undies, Walter?\n"
@"WALTER:Where's your car, Dude?\n"
@"DUDE:You don't know, Walter?\n"
@"WALTER:Hmm. It was parked in a handicapped zone. Perhaps they towed it.\n"
@"DUDE:You fucking know it's been stolen!\n"
@"WALTER:Well, certainly that's a possibility, Dude--\n"
@"DUDE:Aw, fuck it.\n"
@"DONNY:Where you going, Dude?\n"
@"DUDE:I'm goin' home, Donny.\n"
@"DONNY:Your phone's ringing, Dude.\n"
@"DUDE:Thank you, Donny.\n"
@"DUDE:Uh, yeah, uh, green. Some uh, brown, uh or, rust, coloration.\n"
@"YOUNGER COP:And was there anything of value in the car?\n"
@"DUDE:Oh uh, yeah. Uh, a tape deck. Some Creedence tapes. And there was a, uh. . .uh my briefcase.\n"
@"YOUNGER COP:In the briefcase?\n"
@"DUDE:Uh, uh Papers. Ya know, just papers. Uh you know, my papers. Business papers.\n"
@"YOUNGER COP:And what do you do, sir?\n"
@"DUDE:I'm unemployed.\n"
@"DUDE:My rug was also stolen.\n"
@"YOUNGER COP:Your rug was in the car.\n"
@"DUDE:No. Here.\n"
@"YOUNGER COP:Separate incidents?\n"
@"DUDE:You find them much? Uh these stolen cars?\n"
@"YOUNGER COP:Sometimes. I wouldn't hold out much hope for the tape deck though.\n"
@"OLDER COP:Or the Creedence.\n"
@"DUDE:Well what about uhhhhhh, the briefcase?\n"
@"FEMALE VOICE ON MACHINE:Mr. Lebowski, I'd like to see you. Call when you get home and I'll send a car for you. My name is Maude Lebowski. I'm the one who took your rug.\n"
@"YOUNGER COP:Well, I guess we can close the file on that one.\n"
@"VOICE:Elfranco. Ajuda me abajo. I'll be with you in a moment, Mr. Lebowski.\n"
@"MAUDE:Does the female form make you uncomfor- table, Mr. Lebowski?\n"
@"DUDE:Uh, is that what this is a picture of?\n"
@"MAUDE:In a sense, yes. My art has been commended as being strongly vaginal. Which bothers some men. The word itself makes some men uncomfortable. Vagina.\n"
@"DUDE:Oh yeah?\n"
@"MAUDE:Yes, they don't like hearing it and find it difficult to say. Whereas without batting an eye a man will refer to his \"dick\" or his \"rod\" or his \"Johnson\".\n"
@"DUDE:\"Johnson\"?\n"
@"MAUDE:All right, Mr. Lebowski, let's get down to cases. My father told me he's agreed to let you have the rug, but it was a gift from me to my late mother, and so was not his to give. Now.\n"
@"MAUDE:Your face... As for this \"kidnapping\"--\n"
@"DUDE:Huh?\n"
@"MAUDE:Yes, I know about it. And I know that you acted as courier. And let me tell you something: the whole thing stinks to high heaven.\n"
@"DUDE:Yeah, right, but, but let me explain something about that rug--\n"
@"MAUDE:Do you like sex, Mr. Lebowski?\n"
@"DUDE:Excuse me?\n"
@"MAUDE:Sex. The physical act of love. Coitus. Do you like it?\n"
@"DUDE:I was talking about my rug.\n"
@"MAUDE:You're not interested in sex?\n"
@"DUDE:You mean coitus?\n"
@"MAUDE:I like it too. It's a male myth about feminists that we hate sex. It can be a natural, zesty enterprise. However there are some people--it is called satyriasis in men, nymphomania in women--who engage in it compulsively and without joy.\n"
@"DUDE:Oh, no.\n"
@"MAUDE:Oh yes Mr. Lebowski, these unfortunate souls cannot love in the true sense of the word. Our mutual acquaintance Bunny is one of these.\n"
@"DUDE:Listen, Maude uh, I'm sorry if your stepmother is a nympho, but uh, I don't see what this has to do with uh--do you have any Kahlua?\n"
@"MAUDE:Take a look at this, sir.\n"
@"DUDE:Hmm?\n"
@"DUDE:Oh, I know that guy. He's a nihilist.\n"
@"DUDE:Karl Hungus.\n"
@"BUNNY:Hi.\n"
@"ULI:Hello. Mein dizbatcher says zere iss somezing wrong mit deine kable.\n"
@"BUNNY:Yeah, come on in, I'm not really sure exactly what's really wrong with the cable.\n"
@"ULI:Dat's vhy day zent me, I'm un exspert.\n"
@"BUNNY:The TV's in here.\n"
@"MAUDE:You recognize her, of course.\n"
@"ULI:Helga, bring mein toolz.\n"
@"BUNNY:Oh, that's my friend Shari. She just came over to use the shower.\n"
@"MAUDE:The story is ludicrous.\n"
@"ULI:Mein nommen ist Karl. ich bin expert.\n"
@"SHARI:You must be here to fix the cable.\n"
@"MAUDE:Good lord. You can imagine where it goes from here.\n"
@"DUDE:He fixes the cable?\n"
@"MAUDE:Don't be fatuous, Jeffrey.\n"
@"MAUDE:Little matter to me that this woman chose to pursue a career in pornography, nor that she has been \"banging\" Jackie Treehorn, to use the parlance of our times. However. I am one of two trustees of the Lebowski Foundation, the other being my father. The Foundation takes youngsters from Watts and--\n"
@"DUDE:Shit yeah, the Achievers.\n"
@"MAUDE:Little Lebowski Urban Achievers, yes, and proud we are of all of them. I asked my father about his withdrawal of a million dollars from the Foundation account and he told me about this \"abduction\", but I tell you it is preposterous. This compulsive fornicator is taking my father for the proverbial ride.\n"
@"DUDE:Yeah, but my-\n"
@"MAUDE:I'm getting to your rug. My father and I don't get along; he doesn't approve of my lifestyle and, needless to say, I don't approve of his. However, I hardly wish to make my father's embezzlement a police matter, so I'm proposing that you try to recover the money from the people you delivered it to.\n"
@"DUDE:Well-- I could do that--\n"
@"MAUDE:If you successfully do so, I will compensate you to the tune of 10% of the recovered sum.\n"
@"DUDE:A hundred.\n"
@"MAUDE:Thousand, yes, bones or clams or whatever you call them.\n"
@"DUDE:Yeah ah, but, but what about my uh--\n"
@"MAUDE:--your rug, yes, well with that money you can buy any number of rugs that don't have sentimental value for me. And I am sorry about that crack on the jaw.\n"
@"DUDE:Oh that's that's fine. It doesn't even uh--\n"
@"MAUDE:Here's the name and number of a doctor who will look at it for you. You will receive no bill. He's a good man, and thorough.\n"
@"DUDE:Tha, tha, That's thoughtful but--\n"
@"MAUDE:Please see him, Jeffrey. He's a good man, and thorough.\n"
@"DUDE:Oh, uh... all right.\n"
@"DRIVER:--So he says, \"My wife's a pain in the ass. She's always tryin' to bust my friggin aggets, my daughter's married to a Jadrool loser bastard, I got a rash so bad on my ass I can't even siddown. But you know me. I can't complain.\"\n"
@"DUDE:Fuckin' A, man. I got a rash man. Fuckin' A...\n"
@"DUDE:...I gotta tell ya Ton' man, earlier in the day, I was feeling really shitty man. Really down in the dumps. Lost a little money...\n"
@"TONY:Heyh you know what? Forgeddaboutit huh, forgedaboutit.\n"
@"DUDE:Yeah, fuck it man! I can't be worried about that shit. Life goes on man!\n"
@"TONY:Well home sweet home, Mr. L.\n"
@"TONY:Hey yo, com'eer. Who's your friend in the Volkswagon?\n"
@"DUDE:Huh?\n"
@"TONY:Yeah, he followed us here.\n"
@"DUDE:When did he start fol-- whoaaaa- what the fuck!\n"
@"SECOND CHAUFFEUR:Into the limo, you sonofabitch. No arguments.\n"
@"DUDE:Hey, hey, hey careful, man! There's a beverage here!\n"
@"LEBOWSKI:Start talking and talk fast you lousy bum!\n"
@"BRANDT:We've been frantically trying to reach you, Dude.\n"
@"LEBOWSKI:Where's my goddamn money, you bum?!\n"
@"DUDE:Well, well we--I, I, I don't--\n"
@"LEBOWSKI:They did not receive the money, you nitwit! They did not receive the money! HER LIFE WAS IN YOUR HANDS!\n"
@"BRANDT:This is our concern, Dude.\n"
@"DUDE:No, man, nothing is fucked here--\n"
@"LEBOWSKI:NOTHING IS FUCKED!\n"
@"DUDE:No man--\n"
@"LEBOWSKI:THE GODDAMN PLANE HAS CRASHED INTO THE MOUNTAIN!\n"
@"DUDE:Well man, come on, who're you gonna believe? Those guys or uh--we dropped off the damn money--\n"
@"LEBOWSKI:WE?!\n"
@"DUDE:I--the royal we, you know, the editorial--I dropped off the money, exactly as per--Look, man I've got certain information alright? Certain things have come to light, and uh, ya know, has it ever occurred to you, that uh, instead of uh, you know running around, uh uh, blaming me, given the nature of all this new shit, you know it, it it, this could be a uh, a lot more uh, uh, uh, uh, complex, I mean it's not just, it might not be, just such a simple, uh--you know?\n"
@"LEBOWSKI:What in God's holy name are you blathering about?\n"
@"DUDE:Well I'll tell you what I'm blathering about! I got information man--new shit has come to light and and--shit, man! She kidnapped herself!\n"
@"DUDE:Well sure man, look at it! Ya know. A young trophy wife, in the parlance of our times, ya know. She uh, uh, owes money all over town, including to known pornographers- ha, and that's cool, that's that's cool-- I- I'm saying, she needs money man, and uh, you know, of course they're gonna say they didn't get it, uh uh, because she wants more, man, she's gotta feed the monkey, I- I mean--uh, hasn't that ever occurred to you man? Sir?\n"
@"LEBOWSKI:No Mr. Lebowski, that had not occurred to me.\n"
@"BRANDT:That had not occurred to us, Dude.\n"
@"DUDE:Uh, okay, ya know, you guys aren't privy to all the new shit, so uh, you know, but hey, that's what you, that's what you pay me for. Aha... The Dude takes a hurried sip from his drink. Um. Speaking of which, do you think uh, that you could uh, give me my twenty thousand in cash? Uh, my concern is, and I've gotta check with, with my accountant, but that this might bump me up into a higher tax uh--\n"
@"LEBOWSKI:Brandt, give him the envelope.\n"
@"DUDE:Oh well, if you've already got the, check made out, that that's cool. Brandt is handing him a letter sized envelope which is distended by something inside.\n"
@"BRANDT:We received it this morning.\n"
@"LEBOWSKI:Since you have failed to achieve, even in the modest task that was your charge, since you have stolen my money, since you have unrepentantly betrayed my trust. I have no choice but to tell these bums to do whatever is necessary to recover their money from you, Jeffrey Lebowski. And with Brandt as my witness, I will tell you this:\n"
@"LEBOWSKI:Any further harm visited upon Bunny, will be visited tenfold upon your head.\n"
@"LEBOWSKI:...My God sir. I will not abide another toe.\n"
@"WALTER (LAUGHING):That wasn't her toe dude.\n"
@"DUDE:Whose toe was it, Walter?\n"
@"WALTER:How the fuck should I know? I do know that nothing about it indicates--\n"
@"DUDE:The nail polish, Walter.\n"
@"WALTER:Fine, Dude. As if it's impossible to get some nail polish, apply it to someone else's toe--\n"
@"DUDE:Someone else's--where the fuck are they gonna get--\n"
@"WALTER:You want a toe? I can get you a toe, believe me. There are ways, Dude.\n"
@"DUDE:But Walter--\n"
@"WALTER:You don't wanna know about it, believe me.\n"
@"DUDE:Yeah, but Walter--\n"
@"WALTER:Hell I can get you a toe by 3 o'clock this afternoon--with nail polish. These fucking amateurs.\n"
@"DUDE:Walter--\n"
@"WALTER:They send us a toe, we're supposed to shit ourselves with fear. Jesus Christ.\n"
@"DUDE:Walter--\n"
@"WALTER:The point is--\n"
@"DUDE:They're gonna kill her, Walter, and then they're gonna kill me--\n"
@"WALTER:Dude that's, that's just the stress talking, man. Now so far we have what appears to me, to be a series of victimless crimes--\n"
@"DUDE:What about the toe?\n"
@"WALTER:FORGET ABOUT THE FUCKING TOE!\n"
@"WAITRESS:Excuse me sir, could you please keep your voices down, this is a family restaurant.\n"
@"WALTER:Oh, please dear! For your information: the Supreme Court has roundly rejected prior restraint!\n"
@"DUDE:C'mon Walter, this is not a First Amendment thing, man.\n"
@"WAITRESS:Sir, if you don't calm down I'm going to have to ask you to leave.\n"
@"WALTER:Lady, I got buddies who died face- down in the muck so that you and I could enjoy this family restaurant!\n"
@"DUDE:All right, I'm out of here.\n"
@"WALTER:Hey Dude, don't go away man! Com'on, this affects all of us man!\n"
@"WALTER:Our basic freedoms!\n"
@"WALTER:I'm staying. I'm finishing my coffee.\n"
@"WALTER:Enjoying my coffee.\n"
@"VOICE THROUGH MACHINE:Mr. Lebowski, this is Duty Officer Rolvaag of the L.A.P.D. We've recovered your automobile. It can be claimed at...\n"
@"DUDE:Ahhhh...\n"
@"VOICE THROUGH MACHINE:...the North Hollywood Auto Circus there on Victory.\n"
@"DUDE:Far out.\n"
@"MESSAGE:...The hours there on weekdays will be 10:30 to 5\n"
@"DUDE:Far fuckin' out.\n"
@"MESSAGE:You'll just need to present a claim-\n"
@"DUDE:Hey! Hey! This is a private residence, man!\n"
@"DUDE:Ah, nice marmot.\n"
@"FIRST MAN:Ver is za money Lebowski. Vee vant zat money, Lebowski.\n"
@"SECOND MAN:You sink veer kidding und making mit de funny stuff?\n"
@"THIRD MAN:Vee could do things you only dreamed of, Lebowski.\n"
@"SECOND MAN:Ja, vee belief in nossing.\n"
@"ULI:Vee belief in nossing, Lebowski! NOSSING!! ... und tomorrow vee come back und vee cut off your chonson.\n"
@"DUDE:Excuse me?\n"
@"ULI:I SAY VEE CUT OFF YOUR CHONSON!\n"
@"SECOND MAN:Just sink about zat, Lebowski.\n"
@"ULI:Ja, your viggly penis, Lebowski.\n"
@"SECOND MAN:Ja, und maybe vee stamp on it und skvush it, Lebowski!\n"
@"POLICEMAN:It was discovered last night in Van Nuys, uh lodged against an abutment.\n"
@"DUDE:Oh man, lodged where!!\n"
@"POLICEMAN:You're lucky she didn't get chopped, Mr. Lebowski.\n"
@"DUDE:Oohh Mannn!\n"
@"POLICEMAN:Must've been a joyride situation; they abandoned the vehicle once they hit the retaining wall.\n"
@"DUDE:Oooh my fucking briefcase man! It's not here! Shit!\n"
@"POLICEMAN:Yeah I saw that on the report. Sorry uh, you gotta get in on the other side. Uh, the side view was found on the road by the car.\n"
@"POLICEMAN:You're lucky they left the tape deck though, and the Creedence.\n"
@"DUDE:Awh! Jesus--what's that smell, man?\n"
@"POLICEMAN:Uh, yeah. Its ah, probably a vagrant, slept in the car. Or maybe just used it as a toilet, and moved on.\n"
@"DUDE:Hey man, are you gonna find these guys? Or, you know uh, I mean, do you got any promising uh, uh, leads? Or--\n"
@"POLICEMAN:Leads, yeah sure. I'll uh, just check with the boys down at the Crime Lab. They uh, got uh, four more detectives working on the case. They've got us working in shifts.\n"
@"POLICEMAN:Leads!\n"
@"POLICEMAN:Wooo...Leads!\n"
@"DUDE:My only hope is that the Big Lebowski kills me before the Germans can cut my dick off.\n"
@"WALTER:Now that is just ridiculous, Dude. No one's going to cut your dick off.\n"
@"DUDE:Thank you Walter.\n"
@"WALTER:Not if I have anything to say about it.\n"
@"DUDE:Thank you Walter. That makes me feel very secure.\n"
@"WALTER:Dude--\n"
@"DUDE:That makes me feel warm inside.\n"
@"WALTER:Now Dude--\n"
@"DUDE:This whole fucking thing--I could be sitting here with just pee stains on my rug.\n"
@"WALTER:Yeah.\n"
@"DUDE:But no man, I gotta--you know.\n"
@"WALTER:Fucking Germans. Nothing changes. Fucking Nazis.\n"
@"DONNY:They were Nazis, Dude?\n"
@"WALTER:Come on, Donny, they were threatening castration!\n"
@"DONNY:Uh-huh.\n"
@"WALTER:Are we gonna split hairs here?\n"
@"DONNY:No--\n"
@"WALTER:Am I wrong?\n"
@"DONNY:Well--\n"
@"DUDE (SOFTLY):Look man...\n"
@"WALTER:Am I--\n"
@"DUDE:Man. They were nihilists, man.\n"
@"WALTER:Huh?\n"
@"DUDE:They kept saying they believe in nothing.\n"
@"WALTER:Nihilists! Fuck me.\n"
@"WALTER:I mean say what you want about the tenets of National Socialism, Dude, at least it's an ethos.\n"
@"DUDE:Yeah.\n"
@"WALTER:And let's also not forget--let's not forget, Dude--that keeping wildlife, uh, an amphibious rodent, for uh, you know, domestic, within the city-- that ain't legal either.\n"
@"DUDE:What're you, a fucking park ranger now?\n"
@"WALTER:No, I'm just trying to uh--\n"
@"DUDE:Who gives a shit about the fucking marmot!\n"
@"WALTER:--We're sympathizing here, Dude--\n"
@"DUDE:Fuck sympathy! I don't need your fucking sympathy, man, I need my fucking Johnson!\n"
@"DONNY:What do you need that for, Dude?\n"
@"WALTER:You gotta buck up, man, you cannot drag this negative energy into the tournament.\n"
@"DUDE:Fuck the tournament! Fuck you, Walter!\n"
@"WALTER:Fuck the tournament?!\n"
@"WALTER:Okay Dude. I can see you don't want to be cheered up here. C'mon Donny, let's go get us a lane.\n"
@"DUDE:Another Caucasian, Gary.\n"
@"VOICE:Right, Dude.\n"
@"DUDE:Friends like these, huh Gary.\n"
@"GARY:That's right, Dude.\n"
@"MAN:D'ya got a good sarsaparilla?\n"
@"BARTENDER:Sioux City Sarsaparilla.\n"
@"THE STRANGER:Yeah, that's a good one.\n"
@"THE STRANGER:How ya doin' there, Dude?\n"
@"DUDE:Not too good, man.\n"
@"THE STRANGER:One a those days, huh.\n"
@"DUDE:Yeap.\n"
@"THE STRANGER:Wal, a wiser fella than m'self once said, sometimes you eat the bar en...\n"
@"THE STRANGER:Much abliged.\n"
@"THE STRANGER:... and sometimes the bar, wal, he eats you.\n"
@"DUDE:Hmm. That some kind of Eastern thing?\n"
@"THE STRANGER:Far from it.\n"
@"THE STRANGER:I like your style, Dude.\n"
@"DUDE:Well I dig your style too, man. Got a whole cowboy thing goin'.\n"
@"THE STRANGER:Thankie, there's just one thing, Dude.\n"
@"DUDE:Whassat?\n"
@"THE STRANGER:D'ya have to use s'many cuss words?\n"
@"DUDE:What the fuck are you talking about?\n"
@"THE STRANGER:Okay Dude, have it your way.\n"
@"THE STRANGER:Take 'er easy, Dude.\n"
@"DUDE:Yeah. Thanks man.\n"
@"GARY:Call for ya, Dude.\n"
@"DUDE:Hello.\n"
@"MAUDE:Jeffrey, you have not gone to the doctor.\n"
@"DUDE:Uh, oh yeah, no no, I haven't yet, Uh--\n"
@"MAUDE:I'd like to see you immediately.\n"
@"DUDE:Oh?\n"
@"MAN:So you're Lebowski?\n"
@"DUDE:Yeah.\n"
@"MAN:Maudie's told me all about you. She'll be back in a minute, sit down. Do you want a drink?\n"
@"DUDE:Yeah, sure, White Russian.\n"
@"MAN:The bar's over there.\n"
@"MAN:So what do you do Lebowski?\n"
@"DUDE:Who the fuck are you man?\n"
@"MAN (SNICKERING):Just a friend of Maudie's.\n"
@"DUDE:Yeah? The friend with the cleft asshole?\n"
@"DUDE:Whadda you do?\n"
@"MAN (GIGGLES AND SNICKERS):Oh, nothing much.\n"
@"MAUDE:Hello Jeffery.\n"
@"MAN (TO MAUDE):Hello.\n"
@"DUDE:Uh, yeah. How are you? Uh, listen Maude, I've got to uh-- tender my resignation or whatever, because uh, looks like your mother really was kidnapped after all.\n"
@"MAUDE:She most certainly was not!\n"
@"DUDE:Hey man, why don't you fucking listen occasionally? You might learn something. Now I got--\n"
@"MAUDE:And please don't call her my mother.\n"
@"MAUDE:She is most definitely the perpetrator and not the victim.\n"
@"DUDE:I'm telling you, I got pretty definitive evidence--\n"
@"MAUDE:From who?\n"
@"DUDE:From the main guy, Uli.\n"
@"MAUDE:Uli Kunkel? Her \"co-star\" in the beaver picture?\n"
@"DUDE:Beav-? You mean vagina?--I mean, you know the guy?\n"
@"MAUDE:I might have introduced them for all I know.\n"
@"MAUDE:Do you remember Uli?\n"
@"MAN:umm.\n"
@"MAUDE:He's a musician, he used to have a group, 'Autoban'. Look in my LPs they released one album in the late seventies.\n"
@"MAUDE:Their music is a sort of--ugh- techno-pop..\n"
@"MAUDE:So he's pretending to be the abductor?\n"
@"DUDE:Well...yeah--\n"
@"MAUDE:Look, Jeffrey, you don't really kidnap someone you're acquainted with. The whole idea is that the hostage can't be able to identify you, after you've let them go.\n"
@"DUDE:Well I, I I know that.\n"
@"DUDE:What the fuck is with this guy? Who is he?\n"
@"MAUDE:Knox Harrington, the video artist.\n"
@"MAUDE:So Uli has the money?\n"
@"DUDE:Well uh, no, not exactly. Uh, uh uh, This is a very complicated case, Maude. You know a Lotta ins, a Lotta outs, a lotta what-have yous. And uh, lotta strands to keep in my head, man. Lotta strands in old Duder's head.\n"
@"KNOX HARRINGTON:Hello.\n"
@"MAUDE:Well if Uli doesn't have it, then who does?\n"
@"KNOX HARRINGTON (LAUGHING):It's Sandro about Biennale.\n"
@"MAUDE:Uh, look, I have to take this\n"
@"MAUDE:Do you still have that doctor's number?\n"
@"DUDE:Huh? No, really, it's not even, not even bruised anymore\n"
@"MAUDE:Oh please Jeffrey. I don't want to be responsible for any delayed after-effects.\n"
@"MAUDE:Di a me Sandro. Si.\n"
@"DUDE:After effects?\n"
@"MAUDE:Si. Si! Che ridiculo.\n"
@"VOICE:Could you slide your shorts down Mr. Lebowski, please?\n"
@"DUDE:Hmm? No, no man, she, she hit me right here.\n"
@"VOICE:I understand. Could you slide your shorts down please?\n"
@"WALTER:He lives in North Hollywood on Radford, near the In-and-Out Burger.\n"
@"DUDE:Uh, the In-and-Out Burger's on Camrose.\n"
@"WALTER:Near the In-and-Out Burger. Th--\n"
@"DONNY:Those are good burgers, Walter.\n"
@"WALTER:Shut the fuck up, Donny. The kid is in ninth grade, Dude, and his father is--are you ready for this?--\n"
@"DUDE:Hmm.\n"
@"WALTER:His father is, Arthur Digby Sellers.\n"
@"DUDE:Who the fuck is that?\n"
@"WALTER:Huh?\n"
@"DUDE:Who the fuck is Arthur Digby Sellers?\n"
@"WALTER:Who the fu-- have you ever heard of a little show called Branded, Dude?\n"
@"DUDE:Yeah. Yes I know--\n"
@"WALTER:All but one man died? There at Bitter Creek?\n"
@"DUDE:Yeah, I know the fucking show Walter, so what?\n"
@"WALTER:Fucking Arthur Digby Sellers wrote 156 episodes, Dude.\n"
@"DUDE:Huh!\n"
@"WALTER:Bulk of the series.\n"
@"DUDE:Ahwww.\n"
@"WALTER:Not exactly a lightweight.\n"
@"DUDE:No.\n"
@"WALTER:And yet his son is a fucking dunce.\n"
@"DUDE:Uh.\n"
@"WALTER:Anyway uh, we'll go there after the uh...\n"
@"WALTER:...what have you. We'll, brace the kid, should be a push over--\n"
@"DONNY:We'll be near the In-and-Out Burger.\n"
@"WALTER:SHUT THE FUCK UP, Donny. We'll, go out there and we'll brace the kid- he should be a pushover. We'll get that fucking million dollars back, if he hasn't spent it already. A million fucking clams. And yes, we'll be near the, uh--\n"
@"DONNY:In-n-Out.\n"
@"DUDE (SOFTLY):Hey, shussh shussh, man.\n"
@"WALTER:...some burgers, some beers, a few laughs. Our fucking troubles are over, Dude.\n"
@"DUDE:Awwww fuck me, man! That kid's already spent all the money man!\n"
@"WALTER:New 'vette? Hardly Dude, I'd say he still has, 960 to 970 thousand dollars left, depending on the options. Wait in the car, Donny.\n"
@"WOMAN:Jace?\n"
@"WALTER:Pilar? My name is Walter Sobchak, this is my associate Jeffrey Lebowski. Uh, we came to talk about little Larry. May we come in?\n"
@"WOMAN:Jace jace.\n"
@"WALTER (SOFTLY):Thank you.\n"
@"WALTER:That's him, Dude.\n"
@"WALTER:AND A GOOD DAY TO YOU, SIR.\n"
@"PILAR:Ay, see down, please.\n"
@"PILAR:Larry! Sweetie! Dat mang is here!\n"
@"WALTER:Is he, . . . Does he still write?\n"
@"PILAR:Oh no, no. He has healt' problems.\n"
@"WALTER:Uh-huh.\n"
@"WALTER:Uh sir, I just want to say, uh, that we're both--on a personal level, really enormous fans. Branded, especially the early episodes, was truly a source of inspiration.\n"
@"PILAR:Sweetie see down. This man is the police.\n"
@"WALTER:Oh no ma'am, We didn't want to give the impression that we were police exactly. We're hoping it won't be necessary to call the police. But that's up to little Larry here. Isn't it, Larry?\n"
@"WALTER:Is this your homework, Larry?\n"
@"WALTER:Is this your homework, Larry?\n"
@"DUDE:Look, man, is--\n"
@"WALTER:Dude, please!. . .\n"
@"DUDE:Uooh.\n"
@"WALTER:Is this your homework, Larry?\n"
@"DUDE:Just ask him about the car, man.\n"
@"WALTER:Is this yours, Larry? Is this your homework, Larry?\n"
@"DUDE:Is that your car out front?\n"
@"WALTER:Is this your homework, Larry?\n"
@"DUDE:We know it's his fucking homework! Where's the fucking money, you little brat?!\n"
@"WALTER:Look, Larry. . . Have you ever heard of Vietnam?\n"
@"DUDE:Oh, for Christ's sake, Walter!\n"
@"WALTER:You're entering a world of pain, son. We know that this is your homework. We know you stole a car--\n"
@"DUDE:And the fucking money!\n"
@"WALTER:And the fucking money. And we know that this is your homework.\n"
@"DUDE:We're gonna cut your dick off Larry.\n"
@"WALTER:You're KILLING your FATHER, Larry!.\n"
@"WALTER:Alright, this is pointless.\n"
@"WALTER:Ok, time for Plan B. You might want to watch out that front window Larry.\n"
@"WALTER:Son, this is what happens when you FUCK a STRANGER in the ASS.\n"
@"WALTER:Fucking language problem here. Little prick is stonewallin' me.\n"
@"DUDE:Walter, what are you doing man?\n"
@"DUDE:What are you doing?\n"
@"WALTER:Here you go Larry.\n"
@"WALTER:YOU SEE WHAT HAPPENS, YOU SEE WHAT HAPPENS LARRY!\n"
@"WALTER:YOU SEE WHAT HAPPENS?!\n"
@"DUDE:Oh, great.\n"
@"WALTER:THIS IS WHAT HAPPENS WHEN YOU FUCK A STRANGER IN THE ASS LARRY!\n"
@"WALTER:THIS IS WHAT HAPPENS LARRY.\n"
@"WALTER:YOU SEE WHAT HAPPENS LARRY? YOU SEE WHAT HAPPENS! WHEN YOU FUCK A STRANGER IN THE ASS!\n"
@"WALTER:THIS IS WHAT HAPPENS,\n"
@"WALTER:YOU SEE WHAT HAPPENS LARRY?\n"
@"WALTER:YOU SEE WHAT HAPPENS LARRY?\n"
@"WALTER:YOU SEE WHAT HAPPENS LARRY WHEN YOU FUCK A STRANGER IN THE ASS?\n"
@"WALTER:THIS IS WHAT HAPPENS LARRY!\n"
@"WALTER:THIS IS WHAT HAPPENS LARRY!\n"
@"VOICE:MY CAR!\n"
@"WALTER:THIS IS WHAT HAPPENS LARRY!\n"
@"VOICE:MY BABY, STOP IT!\n"
@"WALTER:THIS IS WHAT HAPPENS WHEN YOU FUCK A STRANGER--\n"
@"MAN:WHAT THE FUCK JOO DOING, MANG?! STOP IT!\n"
@"WALTER:Oh hey, hey man.\n"
@"MAN:I JUS' BAWDEEZ FUCKEEN CAR LASS WEEK!\n"
@"WALTER:Whoa, whoa, whoa, whoa,\n"
@"MAN:I'M GONNA FUCKING KILL JOO\n"
@"WALTER:Hey, I'm sorry.\n"
@"MAN:I JUS' BAWDEEZ FUCKEEN CAR LASS WEEK!\n"
@"WALTER:Com'on man.\n"
@"MAN:I KILL JOR FUCKEEN CAR MAN!\n"
@"DUDE:Whoa..No! Hey! Hey! THAT'S NOT his- HEY\n"
@"MAN:FUCK JOO AHHGGG, GOD DAMMIT FUCK JOO!\n"
@"DUDE:Oh no, no man, no.\n"
@"MAN:YOU LIKE DAT, FUCK JOO!\n"
@"DUDE:NO! no awwwww, noooo.\n"
@"MAN:I KILL JOR FUCKEEN CAR MAN!\n"
@"DUDE:Awwww. Heyyyy.\n"
@"MAN:I KILL JOR FUCKEEN CAR!\n"
@"DUDE:I accept your apology. . . No I just, I just want to handle it by myself from now on. No, no . . No! That has nothing to do with it...\n"
@"DUDE:Yes, the car made it home, You're calling at home. No, Walter, it did not look like Larry was about to crack. Well that's your perception. You know Walter you're right, there is an unspoken message here, it's FUCK YOU, LEAVE ME THE FUCK ALONE. . . Yeah, I'll be at practice.\n"
@"WOO:Pin your diapers on, Lebowski. Jackie Treehorn wants to see you.\n"
@"BLOND MAN:Jackie Treehorn knows which Lebowski you are, Lebowski.\n"
@"WOO:Jackie Treehorn wants to see the deadbeat Lebowski.\n"
@"BLOND MAN:You're not dealing with morons here.\n"
@"MAN:Hello, Dude. Thanks for coming. I'm Jackie Treehorn.\n"
@"DUDE:Quite a pad you got here, man. Completely unspoiled.\n"
@"TREEHORN:What's your drink, Dude?\n"
@"DUDE:White Russian, thanks.\n"
@"TREEHORN:White Russian.\n"
@"DUDE:How's the smut business, Jackie?\n"
@"TREEHORN:I wouldn't know, Dude. I deal in publishing, entertainment, political advocacy--\n"
@"DUDE:Which one's Logjammin'?\n"
@"TREEHORN:Yes regrettably, it's true, standards have fallen in adult entertainment. It's video, Dude. Now that we're competing with the amateurs, we can't afford to invest in little extras like story, production value, feelings.\n"
@"TREEHORN:People forget...\n"
@"TREEHORN:...that the brain is the biggest erogenous zone--\n"
@"DUDE:On you, maybe.\n"
@"TREEHORN:Of course, you have to take the good with the bad. The new technology permits us to do very exciting things in interactive erotic software. Wave of the future, Dude. 100% electronic.\n"
@"DUDE:Hmmm. Well, I still jerk off manually.\n"
@"TREEHORN:Ah heh, ha ha Of course you do. Well, I can see you're anxious for me to get to the point. Well, here it is Dude. Where's Bunny?\n"
@"DUDE:Well I thought you might know that, man.\n"
@"TREEHORN:Why would I? She only ran off to get away from that rather sizable debt to me.\n"
@"DUDE:Uuno, she didn't run off, she's been uh--\n"
@"TREEHORN:I've heard the kidnapping story, so save it. I know you're mixed up in all this, Dude, and I don't care what you're trying to get from the husband. That's your business. All I'm saying is, I want mine.\n"
@"DUDE:Yeah, right man, there are a lot of uh, facets uh, to this. A lotta interested parties uh--\n"
@"TREEHORN:Excuse me.\n"
@"TREEHORN:Yeah, Oh yeah? Where's that?\n"
@"TREEHORN:Alright.\n"
@"TREEHORN:Excuse me.\n"
@"DUDE:Hummm!\n"
@"TREEHORN:Forgive me.\n"
@"DUDE:No problemo man... So uh, if I uh, can find your money, ah, what's in it for the Dude?\n"
@"TREEHORN:Well of course, there's that to discuss. A Refill?\n"
@"DUDE:Yeah, did the Pope shit in the woods?\n"
@"TREEHORN:A 10% finder's fee? Is that alright?\n"
@"DUDE:Uumm! Okay, done Jackie. Yeah, I dig the way you do business man. Your money is being held by a kid named Larry Sellers. He lives in North Hollywood, on Radford, Uh, by the In-and-Out Burger.\n"
@"DUDE:A real fuckin' brat, but I'm sure your goons can get it off uh, him I mean he's fifteen...unh flunking social studies. So if you could just uh, write me a check for my ten percent. . . of half a million . . . five grand.\n"
@"DUDE:I'll go out and mingle.--Ahem um, you mix a hell of a Caucasian, Jackie.\n"
@"TREEHORN:A fifteen-year-old? Is this some sort of a joke?\n"
@"DUDE:Awww, no joke. No funny stuff, Jackie . . . the kid's got it. Hi, fellas . . . kid just wanted a car.\n"
@"DUDE:All the Dude ever wanted . . . was his rug back . . . not greedy . . . it really...\n"
@"DUDE:...tied the room together.\n"
@"THE STRANGER'S VOICE:Darkness warshed over the Dude-- darker'n a black steer's tookus on a moonless prairie night. There was no bottom.\n"
@"DUDE:He was innocent. Not a charge was true. And they say he ran awaaaaaay. BRANDED!\n"
@"CHIEF:Is this your only I.D.?\n"
@"DUDE:I know my rights man.\n"
@"CHIEF:You don't know shit, Lebowski.\n"
@"DUDE:I want a fucking lawyer, man. I want Bill Kunstler, man...or umm, or Ronald Kuby.\n"
@"CHIEF:Mr. Treehorn tells us that he had to eject you from his garden party, that you were drunk and abusive.\n"
@"DUDE:Mr. Treehorn, treats objects like, women man.\n"
@"CHIEF:Mr. Treehorn draws a lot of water in this town, You don't draw shit Lebowski. Now we got a nice quiet little beach community here, and I aim to keep it nice and quiet. So let me make something plain. I don't like you sucking around bothering our citizens, Lebowski. I don't like your jerk-off name, I don't like your jerk-off face, I don't like your jerk-off behavior, and I don't like you, jerk-off. Do I make myself clear?\n"
@"DUDE:I'm sorry, I wasn't listening.\n"
@"DUDE:--Ow! Fucking fascist!\n"
@"DUDE:Awwwwwuh!\n"
@"CHIEF:STAY OUT OF MALIBU, LEBOWSKI!!\n"
@"CHIEF:STAY OUT OF MALIBU, DEADBEAT! Keep your ugly fucking goldbricking ass out of my beach community!\n"
@"DUDE'S POV:The back of the driver, a large black man with a brimless, black leather cap on his head.\n"
@"DUDE:Jesus, man, can you change the channel?\n"
@"DRIVER:Fuck you man! You don't like my fucking music, get your own fucking cab!\n"
@"DUDE:I've had a really ruff--\n"
@"DRIVER:I'll pull over the side and kick your ass out!\n"
@"DUDE:Man, c'mon I had a rough night, and I hate the fucking Eagles, man.\n"
@"DRIVER:Umm humm!\n"
@"DRIVER:Outta my fucking cab!\n"
@"DUDE:Hey man!\n"
@"DRIVER:Out, get--\n"
@"DUDE:Man man! Hey!\n"
@"DUDE:Awwwwh Jesus.\n"
@"DUDE:Ummph.\n"
@"MAUDE:Jeffrey.\n"
@"DUDE:Maude?\n"
@"MAUDE:Love me.\n"
@"DUDE:Uh, that's my robe.\n"
@"MAUDE:Tell me a about yourself, Jeffrey.\n"
@"DUDE:Well, not much to tell.\n"
@"DUDE:I uh, I was, uh, one of the authors of the Port Huron Statement.-- Uh the original Port Huron Statement.\n"
@"MAUDE:Uh-huh.\n"
@"DUDE:Not the compromised second draft.\n"
@"DUDE:Uh, and then I, uh. . . ummm, ever hear of the Seattle Seven?\n"
@"MAUDE:Mmnun.\n"
@"DUDE:That was me...and uh, uh, six other guys. Uhh, And then uh . . . the music business briefly.\n"
@"MAUDE:Oh?\n"
@"DUDE:Yeah. Roadie for Metallica.\n"
@"MAUDE:Oh.\n"
@"DUDE:Speed of Sound Tour.\n"
@"MAUDE:Mmm hmmm.\n"
@"DUDE:Bunch of assholes. And then, uh, you know, a little of this, a little of that.\n"
@"DUDE:Uh, my career's, slowed down a little lately.\n"
@"MAUDE:What do you do for, for recreation?\n"
@"DUDE:Oh, the usual. Bowl. Drive around. The occasional acid flashback.\n"
@"MAUDE:What happened to your house?\n"
@"DUDE:Oh, Jackie Treehorn trashed the place. He thought I had your father's money, he got me out of the way while he looked for it. Cocktail?\n"
@"MAUDE:No thanks. It's not my father's money, it's the Foundation's. Why did he think you have it? And who does?\n"
@"DUDE:Oh, Larry Sellers, this high-school kid. Real fucking brat.\n"
@"DUDE:Ya know, this is a very complicated case, Maude. Lotta ins, lotta outs. Uh, ya know. Fortunately I'm adhering to a pretty strict, uh, drug uh, regimen to keep my mind, you know, uh limber ya know. I'm very fucking close to your father's money.\n"
@"MAUDE:I keep telling you, it's the Foundation's money. Father doesn't have any.\n"
@"DUDE:Ummph, Whadda you talking about? He's fucking loaded.\n"
@"MAUDE:No no, the wealth was all Mother's.\n"
@"DUDE:Waa--he runs stuff, uh, you know--\n"
@"MAUDE:We did let him run one of the companies, briefly, but he didn't do very well at it.\n"
@"DUDE:Ah... he's uh, you know.\n"
@"MAUDE:No. He helps administer the charities now, and I give him a reasonable allowance. He has no money of his own. I know how he likes to present himself; Father's weakness is vanity. Hence the slut.\n"
@"DUDE:Uh. Do you think he uh,--what is that yoga?\n"
@"MAUDE:It increases the chances of conception.\n"
@"DUDE:Increases?\n"
@"MAUDE:Well yes, what did you think this was all about? Fun and games? I want a child.\n"
@"DUDE:Okay, Yeah, okay but let me, let me explain something about the Dude--\n"
@"MAUDE:Look, Jeffrey, I don't want a partner. In fact I don't want the father to be someone I have to see socially, or who'll have any interest in raising the child himself.\n"
@"DUDE:So...that doctor uh.\n"
@"MAUDE:Exactly. Now what happened to your face? Did Jackie Treehorn do that as well?\n"
@"DUDE:No, uhhh, It was the Chief of police of Malibu. A real reactionary . . . So your father . . . Oh yeah, I get it! Yeah, Yeah!\n"
@"MAUDE:What?\n"
@"DUDE:Oh man, my thinking about this case, had become very uptight. Yeah. Your father--\n"
@"MAUDE'S VOICE:Jeffery! What're you talking about?\n"
@"MAUDE'S VOICE:Jeffery!\n"
@"DUDE:Walter, if you're there, pick up the fucking phone man. C'mon Walter, pick it up, man, this is an emergency...\n"
@"WALTER:Dude?\n"
@"DUDE:C'mon I'm not--\n"
@"WALTER:Dude?\n"
@"DUDE:Yeah, listen Walter, I'm at my place, I need you to come pick me up.\n"
@"WALTER:I can't drive, Dude, it's erev shabbos.\n"
@"DUDE:What?\n"
@"WALTER:Erev shabbas.\n"
@"DUDE:What?!\n"
@"WALTER:Erev shabbos. I can't drive.\n"
@"DUDE:Man!\n"
@"WALTER:I'm not even supposed to pick up the phone, unless it's an emergency.\n"
@"DUDE:This IS a fucking emergency.\n"
@"WALTER:I understand. That's why I picked up the phone.\n"
@"DUDE:WALTER, YOU FUCK, WE GOTTA GO TO PASADENA, MAN! COME PICK ME UP OR I'M OFF THE FUCKING BOWLING TEAM!\n"
@"DUDE:Get out of that fucking car man.\n"
@"DUDE:Get out of that fucking car! Get the fuck out of the car, man!\n"
@"DUDE:Get out of the fuckin--\n"
@"DUDE:Who the fuck are you, man!?\n"
@"MAN:Easy man, relax, man! No physical harm intended!\n"
@"DUDE:Who the fuck are you?\n"
@"MAN:Okay man, I'm okay.\n"
@"DUDE:Why're you following me around? Come on, fuckhead!\n"
@"MAN:Hey, relax man, I'm a brother shamus.\n"
@"DUDE:Brother Shamus? Like an Irish monk?\n"
@"MAN:What the fuck are you talking about? My name's Da Fino! I'm a private snoop! Like you, man!\n"
@"DUDE:What?\n"
@"DA FINO:A dick, man! And let me tell you something: I dig your work. Playing one side against the other--in bed with everybody--fabulous stuff, man.\n"
@"DUDE:I'm not-- fuck it man, just stay away from my fucking lady friend.\n"
@"DA FINO:Hey hey, I'm not messing with your special lady.\n"
@"DUDE:She's not my special lady, she's my fucking lady friend. I'm just helping her conceive, man!\n"
@"DA FINO:Hey, man, I'm not--uh\n"
@"DUDE:Who're you working for? Lebowski? Uh, Jackie Treehorn?\n"
@"DA FINO:The Knudsens.\n"
@"DUDE:The? Who who, who the fuck are the Knudsens?\n"
@"DA FINO:The Knudsens. It's a wandering daughter job. Bunny Lebowski, man. Her real name is Fawn Knudsen. Her parents want her back.\n"
@"DA FINO:See?\n"
@"DUDE:Jesus fucking Christ.\n"
@"DA FINO:Crazy, huh? Ran away about a year ago.\n"
@"DA FINO:The Knudsens told me I should show her this when I found her. It's the family farm.\n"
@"DA FINO:It's outside uhh Moorhead, Minnesota. They think it'll make her homesick.\n"
@"DUDE:Ssss Oh boy. How ya gonna keep 'em down on the farm once they've seen Karl Hungus.\n"
@"DUDE:She's been kidnapped, Da Fino.\n"
@"DA FINO:Oh man, that's terrible.\n"
@"DUDE:Oh I don't know, maybe not, but she's definitely not around.\n"
@"DA FINO:Hey, uh, phfff, maybe you and me could pool our resources--trade information-- uh, professional courtesy--\n"
@"DUDE:Yeah.\n"
@"DA FINO:Compeers, you know what I mean.\n"
@"DUDE:Yeah yeah, I get it. Fuck off, Da Fino. And stay away from my special -- from my fucking lady friend man.\n"
@"ULI:Uhh the lingonberry pancakes.\n"
@"THIRD MAN:Aufwachen (Wake up) Arschloch (asshole)!\n"
@"SECOND MAN:Lingonberry pancakes.\n"
@"THRIRD MAN:Sree picks in blanket.\n"
@"NILHILIST WOMAN:Fur (for) mich (me) auch (too) Heidelberg Pfannkuchen (pancakes), Uli, Heidelberg Pfann(f)kuchen.\n"
@"ULI:She has lingonberry pancakes.\n"
@"THIRD MAN:Oh, mann, wenn ich dann an die Pfannkuchen in Bremen denke. (Oh, man, that makes me think of those pancakes in Bremen).\n"
@"SECOND MAN:Ja, ja, was ist damit? (Yeah, yeah, what about it?).\n"
@"THIRD MAN:Es ware einfach besser (Wouldn't it be better), den richtigen Butter <zu benutzen=\"\"> (to simply <put> proper butter in it), die nicht so wie eine Scheisse ist (the one that's not so shitty). Es schmeckt ganz so nach Kacke, mann! (This really tastes like shit, man!).\n"
@"SECOND MAN:Ja, ja. (Yeah, yeah).\n"
@"DUDE:I mean we totally fucked it up, man. We fucked up his pay-off. We got the kidnappers all pissed off at us, and Lebowski, he yelled at me a lot, but he didn't do anything. Huh?\n"
@"WALTER:Well, sometimes the cathartic, uh...\n"
@"DUDE:No no, I'm saying if he knows I'm a fuck-up, why does he leave me in charge of getting his wife back? Because he doesn't fucking want her back, man! He's had enough! He no longer digs her! It's all a show! Okay? But then, why didn't he give a shit about his million bucks? I mean, he knows we never handed off his briefcase, but he never asked for it back. The million bucks was never in the briefcase. The briefcase was fucking empty, man! The asshole was hoping that they would kill her! You threw out a ringer for a ringer!\n"
@"WALTER:Huut! Okay, but how does all this add up to an emergency?\n"
@"DUDE:Huh?\n"
@"WALTER:I'm saying, I see what you're getting at, Dude, he kept the money, my point is, huum, here we are, it's shabbos, the sabbath, which I'm allowed to break only if it's a matter of life or death--\n"
@"DUDE:Will you come off it Walter. You're not even fucking Jewish, man.\n"
@"WALTER:What the fuck are you talking about?\n"
@"DUDE:Man, you're fucking Polish Catholic.\n"
@"WALTER:What the fuck are you talking about? I converted when I married Cynthia!\n"
@"DUDE:Yeah.\n"
@"WALTER:Come on, Dude!\n"
@"DUDE:Yeah, yeah yeah!\n"
@"WALTER:You know this!\n"
@"DUDE:Yeah, and five fucking years ago, you were divorced.\n"
@"WALTER:So, what are you saying? When you get divorced, you turn in your library card? You get a new license? You stop being Jewish?\n"
@"DUDE:This is the driveway.\n"
@"WALTER:I'm as Jewish as fucking Tevye\n"
@"DUDE:Man, you know, it's it's all a part of your sick Cynthia thing man. Taking care of her fucking dog. Going to her fucking synagogue. You're living in the fucking past.\n"
@"WALTER:Three thousand years of beautiful tradition, from Moses to Sandy Koufax--YOU'RE GODDAMN RIGHT I'M LIVING IN THE FUCKING PAST! I- Jesus. What the hell happened?\n"
@"WALTER:Un huh, un huh, un huh, un huh. What the fuck?\n"
@"DUDE:AWWWWWH!\n"
@"DUDE:Where was she man?\n"
@"BRANDT:Visiting friends of hers in Palm Springs. She just picked up and left, never bothered to tell us.\n"
@"DUDE:Well I guess the fucking nihilist knew where she was!\n"
@"WALTER:Jesus, Dude! She never even kidnapped herself.\n"
@"BRANDT:Who's this gentleman, Dude?\n"
@"WALTER:Who'm I?\n"
@"DUDE:C'mon.\n"
@"WALTER:I'm a fucking veteran, that's who I am!\n"
@"BRANDT:You shouldn't go in there, Dude! He's very angry!\n"
@"DUDE:SO man!\n"
@"LEBOWSKI:So? She's back. No thanks to you.\n"
@"DUDE:Where's the fucking money, Lebowski?\n"
@"WALTER:A MILLION BUCKS...\n"
@"DUDE:Hey...\n"
@"WALTER:...FROM FUCKING NEEDY LITTLE...\n"
@"DUDE:Walter...\n"
@"WALTER:...URBAN ACHIEVERS! YOU ARE SCUM, MAN!\n"
@"LEBOWSKI:Who the hell is he?\n"
@"WALTER:Who am I, Who am I?\n"
@"DUDE:Walter...\n"
@"WALTER:I'm the guy who's gonna KICK...\n"
@"DUDE:Walter wait...\n"
@"WALTER:...YOUR PHONY GOLDBRICKING ASS! That's who I am!\n"
@"DUDE:MAN! We know the briefcase was fucking empty, We know you kept the million bucks for yourself.\n"
@"LEBOWSKI:You have your story, I have mine. I say I entrusted the money to you, and you stole it.\n"
@"WALTER:AS IF WE WOULD EVER DREAM OF TAKING YOUR BULLSHIT MONEY!\n"
@"DUDE:You thought that Bunny had been kidnapped and you were fucking glad man. You could use it as an excuse to make some money disappear. All you needed was a sap to pin it on, and you'd just met me. You you, human paraquat! You figured, oh, here's a loser, you know a, a a, deadbeat, someone the square community won't give a shit about.\n"
@"LEBOWSKI:Well? Aren't ya?\n"
@"DUDE:Well . . . yeah, but you--\n"
@"LEBOWSKI:Get out. Both of you.\n"
@"WALTER:Look at that fucking phony, Dude! Pretending to be a fucking millionaire!\n"
@"LEBOWSKI:Out of this house. Now you bums.\n"
@"WALTER:Let me tell you something else. I've seen a lot of spinals, Dude, and this guy is a fake. A fucking goldbricker.\n"
@"LEBOWSKI:Stay away from me, mister!\n"
@"WALTER:This guy fucking walks. I've never been more certain of anything in my life!\n"
@"LEBOWSKI:You stay away from me.\n"
@"DUDE:WALTER, FOR CHRIST'S SAKE! HE'S A CRIPPLE!\n"
@"WALTER:I've never been more certain of anything in my life.\n"
@"LEBOWSKI:Stay away from me I said.\n"
@"WALTER:C'mon, c'mon.\n"
@"LEBOWSKI:Get away from me!\n"
@"DUDE:WALTER!\n"
@"WALTER:Walk, you fucking phony!\n"
@"DUDE:PUT HIM DOWN MAN!\n"
@"WALTER:Yeah, I'll put him down, Dude. RAUSS! ACHTUNG, BABY!!\n"
@"DUDE:C'mon man, help me put him back in his chair.\n"
@"WALTER:Sure you'll see some tank battles. But fighting in desert is very different from fighting in canopy jungle.\n"
@"DUDE:Umm humm.\n"
@"WALTER:I mean 'Nam was a foot soldier's war whereas, uh, this thing should uh, you know, be a piece of cake. I mean I had an M16, Jacko, not an Abrams fucking tank. Me and Charlie, eyeball to eyeball.\n"
@"DUDE:Yeah.\n"
@"WALTER:That's fuckin' combat. The man in the black pyjamas, Dude. Worthy fuckin' adversary.\n"
@"DONNY:Who's in pyjamas, Walter?\n"
@"WALTER:Shut the fuck up, Donny. Where as what we have here, a bunch of fig eaters, wearing towels on their heads tryin' to find reverse on a Soviet tank. This, this is not a worthy fucking adversary.\n"
@"VOICE:HEY!\n"
@"QUINTANA:What's this \"day of rest\" shit?! What's this bullshit, I don't fucking care! It don't matter to Jesus! But you're not fooling me man! You might fool the fucks in the league office, but you don't fool Jesus! It's bush league psych out stuff! Laughable, man! HA HA! I would've fucked you in the ass Saturday, I'll fuck you in the ass next Wednesday instead! WHAOOOO!\n"
@"QUINTANA:You got a date Wednesday, baby!\n"
@"WALTER:He's cracking.\n"
@"WALTER:The whole concept abates, I mean many learned men have disputed this, but in the 14th century the Rambam he like...he....\n"
@"DUDE:Well, they finally did it. They killed my fucking car.\n"
@"ULI:Vee vant zat money, Lebowski.\n"
@"SECOND MAN:Ja, uzzervize vee kill ze girl.\n"
@"THRID MAN:Ja, it seems you forgot our little deal, Lebowski.\n"
@"DUDE:You don't have the fucking girl, dipshit. We know you never did.\n"
@"DONNY:Are these the Nazis, Walter?\n"
@"WALTER:No Donny, these men are nihilists, there's nothing to be afraid of.\n"
@"ULI:Vee don't care. Vee still vant zat money Lebowski or vee fuck you ups.\n"
@"WALTER:Fuck you. Fuck the three of you.\n"
@"DUDE:Hey, cool it Walter.\n"
@"WALTER:No, without a hostage there is no ransom. That's what ransom is. Those are the fucking rules.\n"
@"SECOND MAN:His girlfriend gafe up her toe!\n"
@"THIRD MAN:She sought we vould get a million dollars!\n"
@"ULI:Iss not fair!\n"
@"WALTER:FAIR! WHO'S THE FUCKING NIHILIST AROUND HERE! YOU, BUNCH OF FUCKING CRYBABIES?!\n"
@"DUDE:Hey, cool it Walter. Hey look, pal, there never was any money. The Big Lebowski gave me an empty briefcase, so take it up with him man.\n"
@"WALTER:And, I would like my undies back!\n"
@"DONNY:Are these guys gonna hurt us, Walter?\n"
@"WALTER:No, Donny. These men are cowards.\n"
@"ULI:Okay. So vee take ze money you haf on you und vee call it eefen.\n"
@"DUDE:Ah hah.\n"
@"WALTER:Fuck you.\n"
@"DUDE:Hey no, come on, Walter, come on, we're ending this thing cheap man.\n"
@"WALTER:No! What's mine is mine.\n"
@"DUDE:Oh, Come on, Walter!.\n"
@"ULI:No funny stuff\n"
@"DUDE:Alright! Alright uh...\n"
@"ULI:No funny stuff!\n"
@"DUDE:I got uh, four bucks...\n"
@"DUDE:...almost five!\n"
@"DONNY:I got eighteen dollars, Dude.\n"
@"WALTER:What's mine is mine.\n"
@"ULI:VEE FUCK YOU UP, MAN! VEE TAKES THE MONEY!\n"
@"WALTER:Come and get it.\n"
@"ULI:VEE FUCK YOU UP!\n"
@"DUDE:Come on man.\n"
@"WALTER:Show me what you got. Nihilist.\n"
@"ULI:I FUCK YOU!\n"
@"DUDE:Walter, come on he's got a sword thing man!\n"
@"WALTER:Dipshit with a nine-toed woman.\n"
@"ULI:I FUCK YOU! FUCK YOU!\n"
@"ULI:I FUCK YOU, I PIG STICK--\n"
@"WALTER:ARRGGG!\n"
@"THE THIRD MAN:I FUCK YOU!\n"
@"DUDE:Take it easy, man!\n"
@"THE THIRD MAN:I FUCK YOU!\n"
@"DUDE:Take the four dollars!\n"
@"THE THIRD MAN:I FUCK YOU! ... I FUCK YOU IN THE ASS!\n"
@"DUDE:I'm gonna hit you with the fuckin' ball man.\n"
@"THE THIRD MAN (TO THE DUDE OFF CAMERA):VEAKLING! I FUCK YOU!\n"
@"WALTER:ANTI-SEMITE!\n"
@"THE THIRD MAN:I FUCK YOU IN THE ASS! I FUCK YOU IN THE ASS!\n"
@"THE THIRD MAN:I FUCK YOU. I FUCK YOU. I FUCK YOU. I FUCK--\n"
@"WALTER:We've got a man down, Dude.\n"
@"DUDE:God! They shot him, man!\n"
@"WALTER:He's not shot. No Dude.\n"
@"DUDE:They shot Donny?\n"
@"WALTER:There weren't any shots fired.\n"
@"DUDE:Huh?\n"
@"WALTER:It's a heart attack. Call the medics, Dude. I'd go myself but I'm pumping blood. Might pass out.\n"
@"WALTER:Rest easy, good buddy, you're doing fine. We got help choppering in.\n"
@"MAN:Hello, gentlemen. You are the bereaved?\n"
@"DUDE:Yeah man.\n"
@"MAN:Francis Donnelly. Pleased to meet you.\n"
@"DUDE:Jeff Lebowski.\n"
@"WALTER:Walter Sobchak.\n"
@"DUDE:The Dude, actually. It's uh...\n"
@"DONNELLY:Excuse me?\n"
@"DUDE:Aw, nothing.\n"
@"DONNELLY:Yes. I understand you're taking away the remains.\n"
@"WALTER:Yeah.\n"
@"DONNELLY:We have the urn.\n"
@"DONNELLY:And I assume this is credit card?\n"
@"WALTER:Yeah.\n"
@"WALTER:UTHUMMm.\n"
@"WALTER:What's this?\n"
@"DONNELLY:That's for the urn.\n"
@"WALTER:Don't need it. We're scattering the ashes.\n"
@"DONNELLY:Yes, so we were informed. However, we must of course transmit the remains to you in a receptacle.\n"
@"WALTER:This is a hundred and eighty dollars.\n"
@"DONNELLY:It is our most modestly priced receptacle.\n"
@"DUDE:Uh, well can we just uh--\n"
@"WALTER:A hundred and eighty dollars?!\n"
@"DONNELLY:They range up to three thousand.\n"
@"WALTER:Uh, we're uh--Uhmm.\n"
@"DUDE:Can't, can't we just rent it from you man?\n"
@"DONNELLY:Sir, this is a mortuary, not a rental house.\n"
@"WALTER:We're scattering the fucking ashes!\n"
@"DUDE:Walter, Walter, Walter--\n"
@"WALTER:WHAT JUST BECAUSE WE'RE BEREAVED DOESN'T MEAN WE'RE SAPS!\n"
@"DONNELLY:Sir, please lower your voices.\n"
@"DUDE:Man, don't you have, you know, something uh, else we can put 'im in? You know?\n"
@"DONNELLY:That is our most modestly priced receptacle.\n"
@"WALTER:GODDAMNIT!! Is there a Ralph's around here?\n"
@"WALTER:Donny was a good bowler, and a good man. He was . . . He was one of us. He was a man who loved the outdoors, and bowling, and as a surfer he explored the beaches of southern California...\n"
@"WALTER:...from La Jolla...\n"
@"WALTER:...to Leo Carillo and up to Pismo. He died--he died as so many young men of his generation, before his time. In your wisdom Lord you took him. As you took so many bright flowering young men, at Khe San and Lan Doc...\n"
@"WALTER:...and Hill 364. These young men gave their lives. And so'd Donny. Donny who loved bowling.\n"
@"WALTER:And so, Theodore--Donald- Karabotsos, in accordance with what we think your dying wishes might well have been, we commit your final mortal remains to the bosom of...\n"
@"WALTER:...the Pacific Ocean, which you loved so well.\n"
@"WALTER:Goodnight, sweet prince.\n"
@"WALTER:Shit.\n"
@"WALTER:Oh shit Dude, I'm sorry.\n"
@"WALTER:Goddamn wind. Fuck.\n"
@"DUDE:Goddamnit Walter! You fucking asshole!\n"
@"WALTER:Shit! Dude, I'm sorry!\n"
@"DUDE:Everything's a fucking travesty with you man!\n"
@"WALTER:Look Dude, I'm sorry. It was an accident!\n"
@"DUDE:What was zat-- What was that shit about Vietnam!\n"
@"WALTER:Look Dude, I'm sorry--\n"
@"DUDE:What the fuck does anything have to do with Vietnam! What the fuck are you talking about?!\n"
@"WALTER:Dude, I'm sorry.\n"
@"DUDE:Fuckin'--\n"
@"DUDE:Fuck, Walter.\n"
@"WALTER:Come on Dude. Hey fuck it man. Let's go bowling.\n"
@"DUDE:Two oat sodas, Gary.\n"
@"GARY:Right. Good luck tomorrow.\n"
@"DUDE:Yeah. Thanks, man.\n"
@"GARY:Aw, sorry to hear about Donny.\n"
@"DUDE:Ah, yeah. Well, you know, sometimes you eat the bar, and, sometimes uh, you know...\n"
@"DUDE:Hey man.\n"
@"THE STRANGER:Howdy do, Dude.\n"
@"DUDE:I wondered if I'd see you again.\n"
@"THE STRANGER:I wouldn't miss the semis.\n"
@"DUDE:Oh yeah?\n"
@"THE STRANGER:How things been goin'?\n"
@"DUDE:Ahh, you know. Strikes and gutters, ups and downs.\n"
@"THE STRANGER:Sure, I gotcha.\n"
@"DUDE:Yeah. Thanks, Gary...Well take care, man, gotta get back.\n"
@"THE STRANGER:Sure. Take it easy, Dude--\n"
@"DUDE:Oh yeah.\n"
@"THE STRANGER:I know that you will.\n"
@"DUDE:Yeah. Well, the Dude abides.\n"
@"THE STRANGER:Heh heh.\n"
@"DUDE:Walter.\n"
@"THE STRANGER:The Dude abides...\n"
@"THE STRANGER:I don't know about you, but I take comfort in that. It's good knowin' he's out there, the Dude, takin' her easy for all us sinners. Shoosh. I sure hope he makes The finals. Welp, that about does her, wraps her all up. Things seem to've worked out pretty good for the Dude'n Walter, and it was a purt good story, dontcha think? Made me laugh to beat the band. Parts, anyway. I didn't like seein' Donny go. But then, I happen to know that there's a little Lebowski on the way. I guess that's the way the whole durned human comedy keeps perpetuatin' it-self, down through the generations, westward the wagons, across the sands a time until we-- aw, look at me, I'm ramblin' again. Wal, uh hope you folks enjoyed yourselves.\n"
@"THE STRANGER:Catch ya later on down the trail.\n"
@"THE STRANGER:...Say friend, ya got any more of that good sarsaparilla?...\n"
;

@implementation Definitions(fjkdlsjfklsdjfklsdfjdksjfkdsfjdskfjksdljfjfdjskfjskd)
+ (void)MessagesPlaceholder
{
    id obj = [@"MessagesPlaceholder" asInstance];

    id arr = [_dialogText split:@"\n"];
    int count = [arr count];
    int num = [Definitions randomInt:count-25];
    id results = nsarr();
    for (int i=0; i<25; i++) {
        id elt = [arr nth:num+i];
        if (elt) {
            [results addObject:elt];
        }
    }
    [obj setValue:results forKey:@"array"];
    id nav = [Definitions navigationStack];
    [nav pushObject:obj];
    [Definitions runWindowManagerForObject:nav];
    exit(0);
}
@end


@interface MessagesPlaceholder : IvarObject
{
    id _array;
    Int4 _rect[MAX_RECT];
    id _buttons;
    id _buttonDicts;
    char _buttonType[MAX_RECT];
    int _buttonDown;
    int _buttonHover;
    int _buttonDownX;
    int _buttonDownY;
    int _buttonDownOffsetX;
    int _buttonDownOffsetY;
    int _buttonDownMinKnobX;
    int _buttonDownMaxKnobX;
    double _buttonDownKnobPct;
    int _scrollY;

    id _bitmap;
    Int4 _r;
    int _cursorY;

    id _buttonRightMouseDownMessage;
    id _navigationRightMouseDownMessage;
}
@end
@implementation MessagesPlaceholder

- (void)drawInBitmap:(id)bitmap rect:(Int4)r
{
    [self setValue:nsarr() forKey:@"buttons"];
    [self setValue:nsarr() forKey:@"buttonDicts"];

    _cursorY = -_scrollY + r.y + 5;
    _r = r;
    [self setValue:bitmap forKey:@"bitmap"];

    [self panelStripedBackground];

    for (int i=0; i<[_array count]; i++) {
        if (_cursorY >= r.y + r.h) {
            break;
        }
        if ([_buttons count] >= MAX_RECT) {
            [self panelText:@"MAX_RECT reached"];
            break;
        }
        id elt = [_array nth:i];
        id tokens = [elt split:@":" maxTokens:2];
        id text = [tokens nth:1];
        if (text) {
            if ([elt hasPrefix:@"DUDE:"]) {
                [self panelChatBubble:text fgcolor:@"#000000" bgcolor:@"#c0c0c0"];
            } else {
                [self panelRightSideChatBubble:text fgcolor:@"#000000" bgcolor:@"#99c5fe"];
            }
            [self panelText:@""];
        }
    }
    [self setValue:nil forKey:@"bitmap"];
}
- (void)panelFillWithColor:(id)color
{
    [_bitmap setColor:color];
    [_bitmap fillRect:_r];
}
- (void)panelHorizontalStripes
{
    [Definitions drawHorizontalStripesInBitmap:_bitmap rect:_r];
}
- (void)panelStripedBackground
{
    [Definitions drawStripedBackgroundInBitmap:_bitmap rect:_r];
}

- (void)panelColor:(id)color
{
    [_bitmap setColor:color];
}

- (void)panelBlankSpace:(int)h
{
    _cursorY += h;
}
- (void)panelLine
{
    [self panelLine:1];
}

- (void)panelLine:(int)h
{
    if (h == 1) {
        [_bitmap drawHorizontalLineAtX:_r.x x:_r.x+_r.w-1 y:_cursorY];
    } else if (h > 1) {
        [_bitmap fillRectangleAtX:_r.x y:_cursorY w:_r.w h:h];
    }
    _cursorY += h;
}

- (void)panelText:(id)text color:(id)color backgroundColor:(id)backgroundColor
{
    text = [_bitmap fitBitmapString:text width:_r.w-20];
    int textWidth = [_bitmap bitmapWidthForText:text];
    int textHeight = [_bitmap bitmapHeightForText:text];
    if (textHeight <= 0) {
        textHeight = [_bitmap bitmapHeightForText:@"X"];
    }

    [_bitmap setColor:backgroundColor];
    [_bitmap fillRectangleAtX:_r.x y:_cursorY w:_r.w h:textHeight];

    int x = _r.x;
    x += (_r.w - textWidth) / 2;
    if (color) {
        [_bitmap setColor:color];
    }
    [_bitmap drawBitmapText:text x:x y:_cursorY];
    _cursorY += textHeight;
}
- (void)panelText:(id)text color:(id)color
{
    text = [_bitmap fitBitmapString:text width:_r.w-20];
    int textWidth = [_bitmap bitmapWidthForText:text];
    int textHeight = [_bitmap bitmapHeightForText:text];
    if (textHeight <= 0) {
        textHeight = [_bitmap bitmapHeightForText:@"X"];
    }

    int x = _r.x;
    x += (_r.w - textWidth) / 2;
    if (color) {
        [_bitmap setColor:color];
    }
    [_bitmap drawBitmapText:text x:x y:_cursorY];
    _cursorY += textHeight;
}
- (void)panelText:(id)text
{
    [self panelText:text color:@"black"];
}

- (void)panelChatBubble:(id)text
{
    [self panelChatBubble:text fgcolor:@"black" bgcolor:@"white"];
}
- (void)panelChatBubble:(id)text fgcolor:(id)fgcolor bgcolor:(id)bgcolor
{
    fgcolor = [fgcolor asRGBColor];
    bgcolor = [bgcolor asRGBColor];
    Int4 r = _r;
    r.x += 5;
    r.y = _cursorY;
    r.w -= 30;
    Int4 chatRect = [Definitions drawChatBubbleInBitmap:_bitmap rect:r text:text fgcolor:fgcolor bgcolor:bgcolor flipHorizontal:NO flipVertical:YES];
    _cursorY += chatRect.h;
}

- (void)panelRightSideChatBubble:(id)text
{
    [self panelRightSideChatBubble:text fgcolor:@"black" bgcolor:@"white"];
}
- (void)panelRightSideChatBubble:(id)text fgcolor:(id)fgcolor bgcolor:(id)bgcolor
{
    fgcolor = [fgcolor asRGBColor];
    bgcolor = [bgcolor asRGBColor];
    Int4 r = _r;
    r.x += 25;
    r.y = _cursorY;
    r.w -= 30;
    Int4 chatRect = [Definitions drawChatBubbleInBitmap:_bitmap rect:r text:text fgcolor:fgcolor bgcolor:bgcolor flipHorizontal:YES flipVertical:YES];
    _cursorY += chatRect.h;
}

- (void)handleMouseDown:(id)event
{
    int x = [event intValueForKey:@"mouseX"];
    int y = [event intValueForKey:@"mouseY"];
    for (int i=0; i<[_buttons count]; i++) {
        if ([Definitions isX:x y:y insideRect:_rect[i]]) {
            _buttonDown = i+1;
            if (_buttonType[i] == 's') {
                _buttonDownX = x;
                _buttonDownY = y;
                _buttonDownOffsetX = x - _rect[i].x;
                _buttonDownOffsetY = y - _rect[i].y;
            }
            return;
        }
    }
    _buttonDown = 0;
}
- (void)handleMouseMoved:(id)event
{
    int x = [event intValueForKey:@"mouseX"];
    int y = [event intValueForKey:@"mouseY"];
    if (_buttonDown && (_buttonType[_buttonDown-1] == 's')) {
        _buttonDownX = x;
        _buttonDownY = y;

        if (_buttonDownMaxKnobX) {
            int knobX = _buttonDownX - _buttonDownOffsetX;
            if (knobX < _buttonDownMinKnobX) {
                knobX = _buttonDownMinKnobX;
            }
            if (knobX > _buttonDownMaxKnobX) {
                knobX = _buttonDownMaxKnobX;
            }
            _buttonDownKnobPct = (double)(knobX - _buttonDownMinKnobX) / (double)(_buttonDownMaxKnobX - _buttonDownMinKnobX);
            id message = [_buttons nth:_buttonDown-1];
            if ([message length]) {
                [self evaluateMessage:message];
            }
        }

        return;
    }
    for (int i=0; i<[_buttons count]; i++) {
        if ([Definitions isX:x y:y insideRect:_rect[i]]) {
            _buttonHover = i+1;
            return;
        }
    }
    _buttonHover = 0;
}

- (void)handleMouseUp:(id)event
{
    if (_buttonDown == 0) {
        return;
    }
    if (_buttonDown && (_buttonType[_buttonDown-1] == 's')) {
        _buttonDown = 0;
        return;
    }
    if (_buttonDown == _buttonHover) {
        id message = [_buttons nth:_buttonDown-1];
        if ([message length]) {
            [self evaluateMessage:message];
        }
    }
    _buttonDown = 0;
}
- (void)handleScrollWheel:(id)event
{
    _scrollY -= [event intValueForKey:@"deltaY"];
}
- (void)handleRightMouseDown:(id)event
{
    if (_buttonHover) {
        id windowManager = [event valueForKey:@"windowManager"];
        int mouseRootX = [event intValueForKey:@"mouseRootX"];
        int mouseRootY = [event intValueForKey:@"mouseRootY"];

        id obj = nil;
        if (_buttonRightMouseDownMessage) {
            obj = [self evaluateMessage:_buttonRightMouseDownMessage];
            [obj setValue:self forKey:@"contextualObject"];
        }

        if (obj) {
            [windowManager openButtonDownMenuForObject:obj x:mouseRootX y:mouseRootY w:0 h:0];
        }
    }
}
@end

