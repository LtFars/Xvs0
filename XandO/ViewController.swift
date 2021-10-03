import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let firstPlayerSound: SystemSoundID = 1104 // 1104
    let secondPlayerSound: SystemSoundID = 1105 // 1105
    let resetButtonSound: SystemSoundID = 1001 // 1001
    let winSound: SystemSoundID = 1035 // 1035
    let drawSound: SystemSoundID = 1154 // 1154
    
    
    private lazy var field = [["_", "_", "_"],
                              ["_", "_", "_"],
                              ["_", "_", "_"]]
    
    private lazy var tag = 0
    private lazy var checker = "X"
    
    
    private lazy var label: UILabel = {
        var label = UILabel()
        label.text = "First player`s turn"
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .bold)
        
        return label
    }()
    
    private lazy var oneButton = createButton()
    private lazy var twoButton = createButton()
    private lazy var threeButton = createButton()
    private lazy var fourButton = createButton()
    private lazy var fiveButton = createButton()
    private lazy var sixButton = createButton()
    private lazy var sevenButton = createButton()
    private lazy var eightButton = createButton()
    private lazy var nineButton = createButton()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "arrow.counterclockwise.circle"), for: .normal)
        button.tintColor = .orange
        button.backgroundColor = nil
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        button.contentEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        button.addTarget(self, action: #selector(resetButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var firstRowStackView = createStackView()
    private lazy var secondRowStackView = createStackView()
    private lazy var thirdRowStackView = createStackView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setupHierarchy()
        setupLayout()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(mainStackView)
        view.addSubview(label)
        view.addSubview(resetButton)
        
        mainStackView.addArrangedSubview(firstRowStackView)
        firstRowStackView.addArrangedSubview(oneButton)
        firstRowStackView.addArrangedSubview(twoButton)
        firstRowStackView.addArrangedSubview(threeButton)
        mainStackView.addArrangedSubview(secondRowStackView)
        secondRowStackView.addArrangedSubview(fourButton)
        secondRowStackView.addArrangedSubview(fiveButton)
        secondRowStackView.addArrangedSubview(sixButton)
        mainStackView.addArrangedSubview(thirdRowStackView)
        thirdRowStackView.addArrangedSubview(sevenButton)
        thirdRowStackView.addArrangedSubview(eightButton)
        thirdRowStackView.addArrangedSubview(nineButton)
    }
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func setupLayout() {
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -20).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 5).isActive = true
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                
        firstRowStackView.translatesAutoresizingMaskIntoConstraints = false
        secondRowStackView.translatesAutoresizingMaskIntoConstraints = false
        thirdRowStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - Private functions
    
    private func createButton() -> UIButton {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "stop"), for: .normal)
        button.tintColor = .orange
        button.tag = tag
        tag += 1
        button.backgroundColor = nil
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        button.contentEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        button.addTarget(self, action: #selector(fieldButtonAction), for: .touchUpInside)
        return button
    }
    
    private func createStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        return stackView
    }
    
    @IBAction func fieldButtonAction(sender: UIButton) {
        if label.text?.first == "F" {
            AudioServicesPlaySystemSound(firstPlayerSound)
            checker = "X"
            sender.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
            label.text = "Second player`s turn"
        } else {
            AudioServicesPlaySystemSound(secondPlayerSound)
            checker = "O"
            sender.setImage(UIImage(systemName: "poweroff"), for: .normal)
            label.text = "First player`s turn"
        }
        sender.isUserInteractionEnabled = false
        
        switch sender.tag {
        case 0:
            field[0][0] = checker
        case 1:
            field[0][1] = checker
        case 2:
            field[0][2] = checker
        case 3:
            field[1][0] = checker
        case 4:
            field[1][1] = checker
        case 5:
            field[1][2] = checker
        case 6:
            field[2][0] = checker
        case 7:
            field[2][1] = checker
        case 8:
            field[2][2] = checker
        default:
            break
        }
        
        switch checker {
        case "X":
            if checkWinner(field, winner: checker) {
                label.text = "First player WIN"
                label.textColor = .systemGreen
                changeButtonInteractive(false)
                AudioServicesPlaySystemSound(winSound)
            }
        case "O":
            if checkWinner(field, winner: checker) {
                label.text = "Second player WIN"
                label.textColor = .systemGreen
                changeButtonInteractive(false)
                AudioServicesPlaySystemSound(winSound)
            }
        default:
            break
        }
        
        if label.textColor != .systemGreen {
            checkField()
        }
        
    }
    
    private func checkField() {
        var count = 0
        for (_, line) in field.enumerated() {
            for (_, cell) in line.enumerated() {
                cell == "_" ? (count += 1) : (count += 0)
            }
        }
        if count == 0 {
            label.text = "Round Draw"
            label.textColor = .systemRed
            AudioServicesPlaySystemSound(drawSound)
        }
    }
    
    @IBAction func resetButtonAction(sender: UIButton) {
        AudioServicesPlaySystemSound(resetButtonSound)
        changeButtonInteractive(true)
        field = [["_", "_", "_"],
                 ["_", "_", "_"],
                 ["_", "_", "_"]]
        let buttons: [UIButton] = [oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton]
        buttons.forEach {
            $0.setImage(UIImage(systemName: "stop"), for: .normal)
            $0.tintColor = .orange
        }
        label.text = "First player`s turn"
        label.textColor = .systemOrange
    }
    
    private func changeButtonInteractive(_ setter: Bool) {
        let buttons: [UIButton] = [oneButton, twoButton, threeButton, fourButton, fiveButton, sixButton, sevenButton, eightButton, nineButton]
        buttons.forEach {
            $0.isUserInteractionEnabled = setter
        }
    }

    private func checkWinner(_ field: [[String]], winner: String) -> Bool {
        
        var buttonsPosition = [String]()
        
        func changeColorOfButtons() {
            for i in buttonsPosition {
                switch i {
                case "0:0":
                    oneButton.tintColor = .systemGreen
                case "0:1":
                    twoButton.tintColor = .systemGreen
                case "0:2":
                    threeButton.tintColor = .systemGreen
                case "1:0":
                    fourButton.tintColor = .systemGreen
                case "1:1":
                    fiveButton.tintColor = .systemGreen
                case "1:2":
                    sixButton.tintColor = .systemGreen
                case "2:0":
                    sevenButton.tintColor = .systemGreen
                case "2:1":
                    eightButton.tintColor = .systemGreen
                case "2:2":
                    nineButton.tintColor = .systemGreen
                default:
                    break
                }
            }
        }
        
        //  Проверка по горизонтали
        for (i, line) in field.enumerated() {
            var count = 0
            for (j, cell) in line.enumerated() {
                if cell == winner {
                    count += 1
                    buttonsPosition.append(String(i)+":"+String(j))
                } else {
                    count = 0
                    buttonsPosition = [String]()
                }
                if count > 2 {
                    changeColorOfButtons()
                    }
                    return true
                }
            }
        
        
        //  Проверка по вертикали
        for index in 0..<field.count {
            var lineElements = [String]()
            
            for (i, line) in field.enumerated() {
                for (j, cell) in line.enumerated() {
                    if index == j {
                        buttonsPosition.append(String(i)+":"+String(j))
                        lineElements.append(cell)
                    }
                }
            }
            var count = 0
            for i in lineElements {
                i == winner ? (count += 1) : (count = 0)
                if count > 2 {
                    changeColorOfButtons()
                    return true }
                else {
                    buttonsPosition = [String]()
                }
            }
        }
        
        //  Проверка по всем диагоналям
        for (i, line) in field.enumerated() {
            for (j, cell) in line.enumerated() {
                if cell == winner {
                    var countMainDiag = 1
                    var countSideDiag = 1
                    var mainX = i+1
                    var mainY = j+1
                    var sideX = i+1
                    var sideY = j-1
                    for (k, line) in field.enumerated() {
                        for (n, cell) in line.enumerated() {
                            
                            //  Проверка по "главной" диагонали
                            if mainX == k && mainY == n {
                                if cell == winner {
                                    mainX += 1
                                    mainY += 1
                                    countMainDiag += 1
                                    if countMainDiag > 2 { return true }
                                } else { countMainDiag = 0 }
                            }
                            
                            //  Проверка по "побочной" диагонали
                            if sideX == k && sideY == n {
                                if cell == winner {
                                    sideX += 1
                                    sideY -= 1
                                    countSideDiag += 1
                                    if countSideDiag > 2 { return true }
                                } else { countSideDiag = 0 }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
}

/*
 
 
 O O X
 X O O
 X X X
 
 
 
 
 */
