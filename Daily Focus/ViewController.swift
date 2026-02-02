import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    
    var tasks: [FocusTask] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Daily Focus"
        
        // load saved data
        tasks = PersistenceManager.load()
        
        // if first time ever, maybe add a default?
        if tasks.isEmpty {
            tasks = [FocusTask(title: "Tap to complete", isCompleted: false)]
        }
        
        configureTableView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        PersistenceManager.save(tasks: tasks)
    }
    
    @objc private func didTapAdd() {
        // 1. Check the "Rule of Three"
        if tasks.count >= 3 {
            showLimitAlert()
            return
        }

        // 2. Create the Alert
        let alert = UIAlertController(title: "New Focus", message: "What is your priority?", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter task..."
        }
        
        // 3. The "Save" Action
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            
            let newTask = FocusTask(title: text, isCompleted: false)
            self.tasks.append(newTask)
            
            // Save and Update UI
            PersistenceManager.save(tasks: self.tasks)
            self.tableView.reloadData()
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }

    private func showLimitAlert() {
        let alert = UIAlertController(
            title: "Limit Reached",
            message: "You can only focus on 3 things at once. Finish something first!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func configureTableView() {
        // 1. add as a sub-view
        view.addSubview(tableView)
        
        // 2. set data-source & delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // 3. register cell type
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        
        // 4. setup constraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = tasks[indexPath.row]
        
        // 1. configuration object
        var content = cell.defaultContentConfiguration()
        
        // 2. set the text
        content.text = task.title
        
        // 3. style text based on completion
        content.textProperties.color = task.isCompleted ? .secondaryLabel : .label
        
        // 4. apply the configuration to cell
        cell.contentConfiguration = content
        
        // 5. add the checkmark accessory
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove from the array
            tasks.remove(at: indexPath.row)
            
            // Save the updated list
            PersistenceManager.save(tasks: tasks)
            
            // Animate the row removal
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // toggle completion status
        tasks[indexPath.row].isCompleted.toggle()
        
        // save new state immediately
        PersistenceManager.save(tasks: tasks)
        
        // reload just that row to show change
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
