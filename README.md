# MyTop8
'MySpace' Top 8 for your Github profile.

Things to research:
+ Docker
+ Checkoutv2 Action and how to interract that from a 2nd step in YAML
+ How to check in repo changes from container 
  + Do rights come from CheckoutV2 Action? o.O
+ PowerShell to parse readme for custom section heading and termination

Techniques to look into:
+ Insertion of newly-generated formatting code to create the top 8 section
 + 3 variables, Something like this?
  + $PreSectionContent = $Content[0..$Indexbeforesection]
  + $SectionToAddBetweenSectionLabels = $NewlyGeneratedCodeFromNamesFile
  + $PostSectionContent = $Content[$IndexAfterSection..(-1)]
  + Then we can just mash these together, output single string to file and poof. magic.
