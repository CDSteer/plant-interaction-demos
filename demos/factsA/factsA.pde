import java.util.ArrayList;
ArrayList<String> stringList = new ArrayList<String>();
ArrayList<Integer> keyList = new ArrayList<Integer>();
// Globals
int g_winW = 1000;   // Window Width
int g_winH = 700;   // Window Height
float number = 0.0;
boolean isIn = false;
int code;

void setup() {
  size(g_winW, g_winH, P3D);
  keyList.add(87);
  keyList.add(65);
  keyList.add(83);
  keyList.add(68);
  keyList.add(70);
  keyList.add(71);
  keyList.add(38);
  keyList.add(37);
  keyList.add(40);
  keyList.add(39);

  stringList.add("If you yelled for 8 years, 7 months and 6 days, you would have produced enough sound energy to heat one cup of coffee.");
  stringList.add("The strongest muscle in proportion to its size in the human body is the tongue.");
  stringList.add("Every time you lick a stamp, you're consuming 1/10 of a calorie.");
  stringList.add("The human heart creates enough pressure when it pumps out to the body to squirt blood 30 feet.");
  stringList.add("Banging your head against a wall uses 150 calories an hour.");
  stringList.add("A person cannot taste food unless it is mixed with saliva. For example, if strong-tasting substance like salt is placed on a dry tongue, the taste buds will not be able to taste it. As soon as a drop of saliva is added and the salt is dissolved, however, a definite taste sensation results. This is true for all foods. Try it!");
  stringList.add("The average person falls asleep in seven minutes.");
  stringList.add("Your stomach has to produce a new layer of mucus every two weeks otherwise it will digest itself");
  stringList.add("Humans are the only primates that don't have pigment in the palms of their hands.");
  stringList.add("Thirty-five percent of the people who use personal ads for dating are already married.");
  stringList.add("It's possible to lead a cow upstairs...but not downstairs.");
  stringList.add("Dogs have four toes on their hind feet, and five on their front feet.");
  stringList.add("The ant can lift 50 times its own weight, can pull 30 times its own weight and always falls over on its right side when intoxicated.");
  stringList.add("A cockroach will live nine days without it's head, before it starves to death.");
  stringList.add("Butterflies taste with their feet.");
  stringList.add("Elephants are the only mamals that can't jump.");
  stringList.add("Starfish don't have brains.");
  stringList.add("Polar bears are left handed.");
  stringList.add("A duck's quack doesn't echo, and no one knows why.");
  stringList.add("An ostrich's eye is bigger that it's brain.");
  stringList.add("The longest recorded flight of a chicken is thirteen seconds.");
  stringList.add("The fingerprints of koala bears are virtually indistinguishable from those of humans, so much so that they could be confused at a crime scene.");
  stringList.add("Snails can sleep for 3 years without eating");
  stringList.add("Porcupines float in water.");
  stringList.add("Armadillos are the only animal besides humans that can get leprosy.");
  stringList.add("Many hamsters only blink one eye at a time.");
  stringList.add("A pregnant goldfish is called a twit.");
  stringList.add("A male emperor moth can smell a female emperor moth up to 7 miles away.");
  stringList.add("A giraffe can clean its ears with its 21-inch tongue!");
  stringList.add("Orcas (killer whales) kill sharks by torpedoing up into to shark's stomach from underneath, causing the shark to explode.");
  stringList.add("Ten percent of the Russian government's income comes from the sale of vodka.");
  stringList.add("The number of possible ways of playing the first four moves per side in a game of chess is 318,979,564,000.");
  stringList.add("The sentence 'The quick brown fox jumps over the lazy dog.' uses every letter in the alphabet. Developed by Western Union to Test telex/two communications");
  stringList.add("The only 15 letter word that can be spelled without repeating a letter is 'uncopyrightable'.");
  stringList.add("Stewardesses' is the longest word that is typed with only the left hand.");
  stringList.add("No word in the English language rhymes with month, orange, silver, and purple.");
  stringList.add("'I am' is the shortest complete sentence in the English language.");
  stringList.add("The Hawaiian alphabet has 12 letters.");
  stringList.add("111,111,111 x 111,111,111 = 12,345,678,987,654,321");
  stringList.add("If you spell out consecutive numbers, you have to go up to one thousand until you would find the letter 'a'");
  stringList.add("Men can read smaller print than women; women can hear better than men.");
  stringList.add("Bullet proof vests, fire escapes, windshield wipers, and laser printers were all invented by women.");
  stringList.add("The reason firehouses have circular stairways is from the days of yore when the engines were pulled by horses. The horses were stabled on the ground floor and figured out how to walk up straight staircases.");
  stringList.add("The airplane Buddy Holly died in was the 'American Pie.' (Thus the name of the Don McLean song.)");
  stringList.add("Each king in a deck of playing cards represents a great king from history. Spades - King David; Clubs - Alexander the Great; Hearts - Charlemagne; and Diamonds - Julius Caesar.");
  stringList.add("Nutmeg is extremely poisonous if injected intravenously.");
  stringList.add("Pearls melt in vinegar.");
  stringList.add("Honey is the only food that doesn't spoil.");
  stringList.add("If you put a raisin in a glass of champagne, it will keep floating to the top and sinking to the bottom.");
  stringList.add("Only one person in two billion will live to be 116 or older.");
  stringList.add("It was discovered on a space mission that a frog can throw up. The frog throws up its stomach first, so the stomach is dangling out of its mouth.Then the frog uses its forearms to dig out all of the stomach's contents and then swallows the stomach back down again.");
  stringList.add("If NASA sent birds into space they would soon die; they need gravity to swallow.");
  stringList.add("Studies show that if a cat falls off the seventh floor of a building, it has about thirty percent less chance of surviving than a cat that falls off the twentieth floor. It supposedly takes about eight floors for the cat to realise what is occurring, relax and correct itself.");
  stringList.add("Emus and kangaroos cannot walk backwards, and are on the Australian coat of arms for that reason.");
  stringList.add("The very first bomb dropped by the Allies on Berlin during World War II killed the only elephant in the Berlin Zoo.");
  stringList.add("More people are killed annually by donkeys than die in aircrashes.");
  stringList.add("Certain frogs can be frozen solid, then thawed, and survive.");
  stringList.add("Cat's urine glows under a black light.");
  stringList.add("A shark can detect one part of blood in 100 million parts of water.");
  stringList.add("A rat can last longer without water than a camel.");
  stringList.add("To escape the grip of a crocodile's jaws, push your thumbs into its eyeballs - it will let you go instantly.");
  stringList.add("If you toss a penny 10000 times, it will not be heads 5000 times,but more like 4950. The heads picture weighs more, so it ends up on the bottom.");
  stringList.add("Babies are born without kneecaps. They don't appear until the child reaches 2-6 years of age.");
  stringList.add("The 3 most valuable brand names on earth: Marlboro, Coca-Cola, and Budweiser, in that order.");
  stringList.add("Coca Cola was originally green.");
  stringList.add("40% of McDonald's profits come from the sales of Happy Meals.");
  stringList.add("Every person has a unique tongue print.");
  stringList.add("The most common name in the world is Mohammed.");
  stringList.add("Intelligent people have more zinc and copper in their hair.");
  stringList.add("The world's youngest parents were 8 and 9 and lived in China in 1910.");
  stringList.add("The youngest Pope was 11 years old.");
  stringList.add("Einstein couldn't speak fluently when he was nine.");
  stringList.add("Leonardo da Vinci could write with one hand and draw with the other at the same time.");
  stringList.add("Sherlock Holmes never said 'Elementary, my dear Watson'.");
  stringList.add("In 'Casablanca', Humphrey Bogart never said 'Play it again, Sam'.");
  stringList.add("In the TV series I Love Lucy, Ricki Ricardo never actually said 'Lucy you have some splaining to do'");
  stringList.add("A 'jiffy' is an actual unit of time: 1/100th of a second.");
  stringList.add("Months that begin on a Sunday will always have a 'Friday the 13th.'");
  stringList.add("First novel ever written on a typewriter: Tom Sawyer");
  stringList.add("The mask used by Michael Myers in the original film 'Halloween' was actually a Captain Kirk mask painted white.");
  stringList.add("James Doohan, who played Lt. Commander Montgomery Scott on Star Trek, was missing the entire middle finger of his right hand.");
  stringList.add("All of the clocks in the movie 'Pulp Fiction' are stuck on 4:20.");
  stringList.add("Debra Winger was the voice of E.T.");
  stringList.add("During the chariot scene in 'Ben Hur' a small red car can be seen in the distance.");
  stringList.add("The first couple to be shown in bed together on prime time television were Fred and Wilma Flintstone.");
  stringList.add("Mel Blanc (the voice of Bugs Bunny) was allergic to carrots.");
  stringList.add("Every day more money is printed for monopoly than the US Treasury.");
  stringList.add("The city with the most Roll Royces per capita: Hong Kong");
  stringList.add("Percentage of Africa that is wilderness: 28% Percentage of North America that is wilderness: 38%");
  stringList.add("Barbie's measurements if she were life size: 39-23-33");
  stringList.add("Cost of raising a medium-sized dog to the age of 11: £4000");
  stringList.add("Clans of long ago that wanted to get rid of their unwanted people without killing them used to burn their houses down - hence the expression 'to get fired.'");
  stringList.add("The name Jeep came from the abbreviation used in the army for the 'General Purpose' vehicle, G.P.");
  stringList.add("The term 'whole 9 yards' came from WWII fighter pilots in the South Pacific. When arming their airplanes on the ground, the .50 caliber machine gun ammo belts measured exactly 27 feet. If the pilots fired all their ammo at a target, it got the 'whole 9 yards.'");
  stringList.add("The phrase 'rule of thumb' is derived from an old English law which stated that you couldn't beat your wife with anything wider than your thumb.");
  stringList.add("The US Interstate road system was designed so that one mile in every five must be straight. These straight sections are usable as airstrips in times of war or other emergencies.");
  stringList.add("The cruise liner Queen Elizabeth II, moves only six inches for each gallon of fuel that it burns.");
  stringList.add("A Saudi Arabian woman can get a divorce if her husband doesn't give her coffee.");
  stringList.add("The dot over the letter 'i' is called a tittle.");
  stringList.add("Most lipstick contains fish scales.");
  stringList.add("Donald Duck comics were banned from Finland because he doesn't wear trousers.");
  stringList.add("Ketchup was sold in the 1830s as medicine");
  stringList.add("You can tell from the statue of a mounted horseman how the rider died. If all four of the horse's feet are on the ground, he died of natural causes. One foot raised means he died from wounds suffered in battle. Two legs raised means he died in action.");
}

void draw(){
  background(255);
  fill(0);
  textSize(22);
  fill(0, 102, 153, 204);
  text(stringList.get((int)number), 20, 50, g_winW-10, g_winH);

}

void keyPressed(){
  isIn = keyList.contains(keyCode);
  code = keyCode;
  if (!keyList.isEmpty()){
    if (isIn) {
      newFact();
      //myRemove(code);
    }
  }
}
void newFact(){
  stringList.remove((int)number);
  if (stringList.size() >= 1){
    number = random(0, stringList.size());
    text(stringList.get((int)number), 20, 50, g_winW-10, g_winH);
  }
}
void myRemove(int code){
  keyList.remove(87);
}
