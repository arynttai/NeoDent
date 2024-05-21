import Foundation

class VerificationViewModel {
    
    private var timer: Timer?
    private var remainingTime: Int = 60
    
    var isButtonEnabled: ((Bool) -> Void)?
    var isErrorLabelHidden: ((Bool) -> Void)?
    var timerUpdate: ((String) -> Void)?
    var canResendCode: ((Bool) -> Void)?
    
    private var enteredCode: String = "" {
        didSet {
            isButtonEnabled?(enteredCode.count == 4)
        }
    }
    
    func updateCode(_ code: String) {
        enteredCode = code
    }
    
    func verifyCode() {
        if enteredCode == "1234" {
            isErrorLabelHidden?(true)
        } else {
            isErrorLabelHidden?(false)
        }
    }
    
    func resendCode() {
        remainingTime = 10
        startTimer()
        canResendCode?(false)
        timerUpdate?("Отправить код повторно через: \(formatTime(remainingTime))")
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            if self.remainingTime <= 0 {
                self.timer?.invalidate()
                self.canResendCode?(true)
                self.timerUpdate?("")
            } else {
                self.timerUpdate?("Отправить код повторно через: \(self.formatTime(self.remainingTime))")
            }
        }
    }
    
    private func formatTime(_ time: Int) -> String {
        return String(format: "%d:%02d", time / 60, time % 60)
    }
}
