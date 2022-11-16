//
//  main.swift
//  CodeStarterCamp_Week4
//
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

/// bodyStatus 타입을 설계합니다.
enum BodyStatus: String {
    case upper = "상체근력", lower = "하체근력", endurance = "근지구력", fatigue = "피로도"
}

/// Error 프로토콜을 채택한 열거형 타입 생성
enum ProgramError: Error {
    case inputIsWrong
    case fatigueIsSerious
}

/// BodyCondition 타입을 설계합니다.
class BodyCondition {
    var upperBodyStrength: Int {
        willSet {
            printChangedStatus(newData: newValue, currentData: upperBodyStrength, part: .upper)
        }
    }
    var lowerBodyStrength: Int {
        willSet {
            printChangedStatus(newData: newValue, currentData: lowerBodyStrength, part: .lower)
        }
    }
    var muscularEndurance: Int {
        willSet {
            printChangedStatus(newData: newValue, currentData: muscularEndurance, part: .endurance)
        }
    }
    var fatigue: Int {
        willSet {
            printChangedStatus(newData: newValue, currentData: fatigue, part: .fatigue)
        }
    }
    
    init(upper: Int, lower: Int, edurance: Int, fatigue: Int) {
        self.upperBodyStrength = upper
        self.lowerBodyStrength = lower
        self.muscularEndurance = edurance
        self.fatigue = fatigue
    }
    
    /// Property Observer 내부에서 값의 변화를 감지하여 값을 출력해줄 함수
    func printChangedStatus(newData: Int, currentData: Int, part: BodyStatus) {
            
        if newData > currentData {
            print("\(part.rawValue)이(가) \(newData - currentData)만큼 상승했습니다.")
        } else if newData == currentData {
        } else {
            print("\(part.rawValue)이(가) \(currentData - newData)만큼 하락했습니다.")
        }
    }
    
    /// 현상태 BodyCondtion을 체크하는 함수
    func checkCurrenStatus() {
        print("현재의 컨디션은 다음과 같습니다.")
        print("\(BodyStatus.upper.rawValue): \(upperBodyStrength)")
        print("\(BodyStatus.lower.rawValue): \(lowerBodyStrength)")
        print("\(BodyStatus.endurance.rawValue): \(muscularEndurance)")
        print("\(BodyStatus.fatigue.rawValue): \(fatigue)")
        print("--------------------------")
    }
}

/// Activity 타입을 설계합니다.
struct Activity {
    let name: String
    let action: (BodyCondition) throws -> Void
}

struct Routine {
    var routineName: String
    var numberOfRepeat: Int
    var activities: [Activity]
    
    /// 루틴 반복 횟수만큼 루틴 운동을 실행해주는 함수
    func doRoutineActivity(user: BodyCondition) {
        for count in 1...numberOfRepeat {
            print("\(count) 번째 \(routineName)을 수행합니다.")
            repeatActivities(user: user)
        }
    }
    
    func repeatActivities(user: BodyCondition) {
        for number in 0...activities.count - 1 {
            doActivity(to: user, do: activities[number])
        }
    }

}

/// 각종 운동에 대한 Activity 인스턴스를 생성하고 내부에 클로져를 통해 해당 운동에 알맞는 상태를 증가 또는 하락시키는 함수 블럭을 설계합니다.
let situp: Activity = Activity(name: "윗몸일으키기", action: { bodyCondition in
    bodyCondition.upperBodyStrength += randomGenerator(from: 10, to: 20, option: true)
    bodyCondition.lowerBodyStrength += 0
    bodyCondition.muscularEndurance += 0
    bodyCondition.fatigue += randomGenerator(from: 10, to: 20, option: true)
    print("--------------------------")
    guard bodyCondition.fatigue <= 100 else {
        throw ProgramError.fatigueIsSerious
    }
})

let squat: Activity = Activity(name: "스쿼트", action: { bodyCondition in
    bodyCondition.upperBodyStrength += 0
    bodyCondition.lowerBodyStrength += randomGenerator(from: 20, to: 30, option: true)
    bodyCondition.muscularEndurance += 0
    bodyCondition.fatigue += randomGenerator(from: 10, to: 20, option: true)
    print("--------------------------")
    guard bodyCondition.fatigue <= 100 else {
        throw ProgramError.fatigueIsSerious
    }
})

let longrun: Activity = Activity(name: "오래 달리기", action: { bodyCondition in
    bodyCondition.upperBodyStrength += randomGenerator(from: 5, to: 10, option: true)
    bodyCondition.lowerBodyStrength += randomGenerator(from: 5, to: 10, option: true)
    bodyCondition.muscularEndurance += randomGenerator(from: 20, to: 30, option: true)
    bodyCondition.fatigue += randomGenerator(from: 20, to: 30, option: true)
    print("--------------------------")
    guard bodyCondition.fatigue <= 100 else {
        throw ProgramError.fatigueIsSerious
    }
})

/// if 문을 지정한 이유는 피로도가 0 이하로 떨어져 - 값이 나오는 것을 방지하기 위함
let relaxation: Activity = Activity(name: "동적휴식", action: { bodyCondition in
    bodyCondition.fatigue += randomGenerator(from: 5, to: 10, option: false)
    if bodyCondition.fatigue < 0 {
        bodyCondition.fatigue = 0
    }
    print("--------------------------")
    guard bodyCondition.fatigue <= 100 else {
        throw ProgramError.fatigueIsSerious
    }
})
  
/// Activity 수행시 지정된 범위 만큼 랜덤한 수를 반환하는 함수
func randomGenerator(from a: Int, to b: Int, option updown: Bool) -> Int {
    var randomValue = Int.random(in: a...b)
    if updown == false {
        randomValue = -randomValue
    }
    return randomValue
}

/// Activity를 수행하는 함수
func doActivity(to condition: BodyCondition, do activity: Activity) {
    print("<<\(activity.name)을(를) 시작합니다>>")
    do {
        try activity.action(condition)
    } catch ProgramError.fatigueIsSerious {
        print("피로도가 100을 넘었습니다. 루틴을 중단합니다.")
        condition.checkCurrenStatus()
        exit(0)
    } catch {
        print("error.")
    }
}


    
/// 값 입력 받는 부분
func inputRepeatCount() throws -> Int {
    var normalValue = 0
    
    print("루틴 반복 횟수를 입력해주세요", terminator: ": ")
    let tempNumberOfRepeat = Int(readLine() ?? "문자나 공백이 입력되었어요.")

    if let checkValue = tempNumberOfRepeat {
        if checkValue <= 0 {
            throw ProgramError.inputIsWrong
        }
    } else {
        throw ProgramError.inputIsWrong
    }

    if let repeatNumber = tempNumberOfRepeat {
        normalValue = repeatNumber
    } else {
        print("에러를 체크했는데 어떻게 또 nil값이 들어와서 종료될까요? 다시 수행하세요!")
    }
    print("--------------------------")
    return normalValue
}

/// 입력 에러를 체크하는 부분
func repeatCount() -> Int {
    var inputNumber = 0
    
    do {
        inputNumber = try inputRepeatCount()
    } catch ProgramError.inputIsWrong {
        print("입력이 잘못되었습니다. 1이상의 정수만 입력하세요.")
        inputNumber = repeatCount()
    } catch {
        print("error.")
    }
    
    return inputNumber
}

/// Harry의 BodyCondition 인스턴스를 생성합니다.
var bodyConditionOfHarry = BodyCondition(upper: 0, lower: 0, edurance: 0, fatigue: 0)

/// routineOfHarry 인스턴스를 생성합니다.
var routineOfHarry = Routine(routineName: "Harry's Routine", numberOfRepeat: repeatCount(), activities: [ longrun, relaxation, situp, relaxation, squat, relaxation])

bodyConditionOfHarry.checkCurrenStatus()
routineOfHarry.doRoutineActivity(user: bodyConditionOfHarry)
bodyConditionOfHarry.checkCurrenStatus()