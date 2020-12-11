//
//  ViewController.swift
//  ChattyJohn*UI
//
//  Created by Zhaoyang Li on 11/25/20.
//

import UIKit

class ViewController: UIViewController {

    let viewModel = ViewModel()
    var currentStringCache = "hello"
    var footerMessage = "John* is currently active"

    @IBOutlet private weak var inputTextField: UITextField! {
        didSet {
            inputTextField.delegate = self
        }
    }
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.rowHeight = UITableView.automaticDimension;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkExistance()
        startResponser()
        view.setbackGorund()
        let _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(checkNewMessage), userInfo: nil, repeats: true)
    }

    @objc private func checkNewMessage() {
        let currentString = viewModel.currentMessage
        if currentString != currentStringCache {
            let indexPath = IndexPath(row: viewModel.conversation.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            currentStringCache = currentString

            footerMessage = "John* is currently avtive"
        }
    }

    private func startResponser() {
        viewModel.startReceivingResponser()
        initializeKeyboard()
    }

    @IBAction func sendButtonTapped(_ sender: Any) {
        if let textFieldText = inputTextField.text {
            let sentMessage = textFieldText
            inputTextField.text = String()
            viewModel.sendHandler(message: sentMessage)
        }
    }

    private func checkExistance() {

        guard let fileUrl = URL(string: viewModel.filePath) else { return }

        let existFlag = FileManager.default.fileExists(atPath: fileUrl.path)

        if !existFlag {
            let alert = UIAlertController(title: "SettingsError", message: "The url settings are not correct", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                fatalError("settings not correct")
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return footerMessage
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversation.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.conversation[indexPath.row].0 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseTableViewCell") as? ResponseTableViewCell else { return UITableViewCell() }
            cell.configureCell(message: viewModel.conversation[indexPath.row].1)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell") as? MessageTableViewCell else { return UITableViewCell() }
            cell.configureCell(message: viewModel.conversation[indexPath.row].1)
            return cell
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func initializeKeyboard() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideHandler))
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc private func hideHandler() {
        view.endEditing(true)
        inputTextField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            self.view.frame.size.height -= 347
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.1) {
            self.view.frame.size.height += 347
        }
    }
}
