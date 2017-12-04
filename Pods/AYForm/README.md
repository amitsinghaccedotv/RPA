# AYForm

## How To Use:

```swift
let form = AYForm(numberOfSections: 4)

form.addFields(cellIdentifier: "FieldTableViewCell", forSection: 0, outputs: ("titleField", "title"), ("subTitleField", "subTitle"))

```

### Delegates:

```swift
func form(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, label: String, cell: UITableViewCell, field: Any, output: Output) {
        
     
  }
    
 func form(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
 
      return nil
 }
    
func form(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

    return nil
 }
 
 ```

### Installation:

#### Cocoapods

```
pod 'AYForm'
```
