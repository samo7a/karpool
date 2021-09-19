import { DirectionsDAOInterface } from './dao'
import { Point, Route } from '../../models-shared/route';


//TODO: Move to test folder working on unit tests.
export class DirectionsDAOMock implements DirectionsDAOInterface {

    getRoute(start: Point, end: Point, waypoints: Point[]): Promise<Route> {
        throw new Error('Not implemented.')
        // return new Route(
        //     waypoints: 
        // )
        // return Promise.resolve({
        //     "waypointOrder": [
        //         1,
        //         0,
        //         2
        //     ],
        //     "polyline": "se}hDbkpxNM?@aF?qABgIBgLLgk@Jo^L{_@Nu_@?kDDeDFgANiAf@qBPe@^s@|@{Ad@{@b@m@rAwBhBiCpDmFb@{@j@{AT_ALw@L}AFeGBqH@yIVaRVqVDmFAaKA}NCgd@Aef@LiPHmKFaGFkFD}S?uW?sI?sPA_R?ia@?kR@eQBiBA}C?oA?QGEIYA{@?]CKIGs@@{@@uB??|@?}@tB?z@Ar@A?tB@zBA`C?jJ?rG?bN@vP?vA`AA|DEhLG|CEvBEn@IVGtA@zD?zQ@pKDbR@hP@~AAbD?jCA|DBxA@@hGArDd@?j@@lC??{LdJBzOJrSJ|LDtD@?uD?uF@oK@sL?{B?cAFO?A@sBBeEAiBIU?OA{D?uEAaI?gXA_g@AuA@wBAeIAuMAuUCkL@_CHgA?_HCyHGY?gA?uD?oEB{NCiSEiNoG?kJAkD?jD?jJ@nG?DhNBnIA|RAfK?tD?fAGVAxC?|DdDAjCC\\KlE?lB?bS?`WAfEC\\?HDRB|@J`A^RL\\\\TNXJ`@BPAd@Kb@U~@s@n@Wh@I\\I`D?`CApSExVCzREpUG`[EvJ?lAA?cB?eK?q@xA?v@?",
        //     "legs": [
        //         {
        //             "distance": 10339,
        //             "duration": 878,
        //             "startPoint": {
        //                 "x": -82.8281804,
        //                 "y": 27.8436234
        //             },
        //             "endPoint": {
        //                 "x": -82.7264555,
        //                 "y": 27.8403769
        //             },
        //             "steps": [
        //                 {
        //                     "distance": 7,
        //                     "duration": 2,
        //                     "startPoint": {
        //                         "x": -82.8281804,
        //                         "y": 27.8436234
        //                     },
        //                     "endPoint": {
        //                         "x": -82.8281817,
        //                         "y": 27.8436907
        //                     },
        //                     "instruction": "Head <b>north</b> on <b>137th St</b>/<wbr/><b>Antilles Dr</b> toward <b>Park Blvd N</b>"
        //                 },
        //                 {
        //                     "distance": 10098,
        //                     "duration": 828,
        //                     "startPoint": {
        //                         "x": -82.8281817,
        //                         "y": 27.8436907
        //                     },
        //                     "endPoint": {
        //                         "x": -82.7268352,
        //                         "y": 27.8390631
        //                     },
        //                     "instruction": "Turn <b>right</b> at the 1st cross street onto <b>Park Blvd N</b><div style=\"font-size:0.9em\">Pass by Burger King (on the right in 6.2&nbsp;mi)</div>"
        //                 },
        //                 {
        //                     "distance": 75,
        //                     "duration": 16,
        //                     "startPoint": {
        //                         "x": -82.7268352,
        //                         "y": 27.8390631
        //                     },
        //                     "endPoint": {
        //                         "x": -82.7261324,
        //                         "y": 27.8392276
        //                     },
        //                     "instruction": "Turn <b>left</b> toward <b>65th St N</b>"
        //                 },
        //                 {
        //                     "distance": 128,
        //                     "duration": 27,
        //                     "startPoint": {
        //                         "x": -82.7261324,
        //                         "y": 27.8392276
        //                     },
        //                     "endPoint": {
        //                         "x": -82.72615019999999,
        //                         "y": 27.8403765
        //                     },
        //                     "instruction": "Turn <b>left</b> at the 1st cross street onto <b>65th St N</b>"
        //                 },
        //                 {
        //                     "distance": 30,
        //                     "duration": 5,
        //                     "startPoint": {
        //                         "x": -82.72615019999999,
        //                         "y": 27.8403765
        //                     },
        //                     "endPoint": {
        //                         "x": -82.7264555,
        //                         "y": 27.8403769
        //                     },
        //                     "instruction": "Turn <b>left</b> onto <b>76th Ave N</b><div style=\"font-size:0.9em\">Destination will be on the right</div>"
        //                 }
        //             ]
        //         },
        //         {
        //             "distance": 3772,
        //             "duration": 429,
        //             "startPoint": {
        //                 "x": -82.7264555,
        //                 "y": 27.8403769
        //             },
        //             "endPoint": {
        //                 "x": -82.7389707,
        //                 "y": 27.818236
        //             },
        //             "steps": [
        //                 {
        //                     "distance": 30,
        //                     "duration": 6,
        //                     "startPoint": {
        //                         "x": -82.7264555,
        //                         "y": 27.8403769
        //                     },
        //                     "endPoint": {
        //                         "x": -82.72615019999999,
        //                         "y": 27.8403765
        //                     },
        //                     "instruction": "Head <b>east</b> on <b>76th Ave N</b> toward <b>65th St N</b>"
        //                 },
        //                 {
        //                     "distance": 128,
        //                     "duration": 40,
        //                     "startPoint": {
        //                         "x": -82.72615019999999,
        //                         "y": 27.8403765
        //                     },
        //                     "endPoint": {
        //                         "x": -82.7261324,
        //                         "y": 27.8392276
        //                     },
        //                     "instruction": "Turn <b>right</b> at the 1st cross street onto <b>65th St N</b>"
        //                 },
        //                 {
        //                     "distance": 1041,
        //                     "duration": 123,
        //                     "startPoint": {
        //                         "x": -82.7261324,
        //                         "y": 27.8392276
        //                     },
        //                     "endPoint": {
        //                         "x": -82.7367189,
        //                         "y": 27.8392227
        //                     },
        //                     "instruction": "Turn <b>right</b> onto <b>Park Blvd N</b><div style=\"font-size:0.9em\">Pass by KFC (on the right)</div>"
        //                 },
        //                 {
        //                     "distance": 2331,
        //                     "duration": 200,
        //                     "startPoint": {
        //                         "x": -82.7367189,
        //                         "y": 27.8392227
        //                     },
        //                     "endPoint": {
        //                         "x": -82.73673529999999,
        //                         "y": 27.8184262
        //                     },
        //                     "instruction": "Turn <b>left</b> onto <b>71st St N</b>"
        //                 },
        //                 {
        //                     "distance": 220,
        //                     "duration": 52,
        //                     "startPoint": {
        //                         "x": -82.73673529999999,
        //                         "y": 27.8184262
        //                     },
        //                     "endPoint": {
        //                         "x": -82.738968,
        //                         "y": 27.81843
        //                     },
        //                     "instruction": "Turn <b>right</b> onto <b>51st Ave N</b>"
        //                 },
        //                 {
        //                     "distance": 22,
        //                     "duration": 8,
        //                     "startPoint": {
        //                         "x": -82.738968,
        //                         "y": 27.81843
        //                     },
        //                     "endPoint": {
        //                         "x": -82.7389707,
        //                         "y": 27.818236
        //                     },
        //                     "instruction": "Turn <b>left</b> onto <b>72nd St N</b>"
        //                 }
        //             ]
        //         },
        //         {
        //             "distance": 6828,
        //             "duration": 661,
        //             "startPoint": {
        //                 "x": -82.7389707,
        //                 "y": 27.818236
        //             },
        //             "endPoint": {
        //                 "x": -82.6877397,
        //                 "y": 27.8104953
        //             },
        //             "steps": [
        //                 {
        //                     "distance": 103,
        //                     "duration": 25,
        //                     "startPoint": {
        //                         "x": -82.7389707,
        //                         "y": 27.818236
        //                     },
        //                     "endPoint": {
        //                         "x": -82.738979,
        //                         "y": 27.8173101
        //                     },
        //                     "instruction": "Head <b>south</b> on <b>72nd St N</b> toward <b>51st Ave N</b>"
        //                 },
        //                 {
        //                     "distance": 219,
        //                     "duration": 51,
        //                     "startPoint": {
        //                         "x": -82.738979,
        //                         "y": 27.8173101
        //                     },
        //                     "endPoint": {
        //                         "x": -82.7367572,
        //                         "y": 27.8173122
        //                     },
        //                     "instruction": "Turn <b>left</b> onto <b>50th Ave N</b>"
        //                 },
        //                 {
        //                     "distance": 1215,
        //                     "duration": 121,
        //                     "startPoint": {
        //                         "x": -82.7367572,
        //                         "y": 27.8173122
        //                     },
        //                     "endPoint": {
        //                         "x": -82.736942,
        //                         "y": 27.8063845
        //                     },
        //                     "instruction": "Turn <b>right</b> onto <b>71st St N</b>"
        //                 },
        //                 {
        //                     "distance": 4843,
        //                     "duration": 399,
        //                     "startPoint": {
        //                         "x": -82.736942,
        //                         "y": 27.8063845
        //                     },
        //                     "endPoint": {
        //                         "x": -82.6877497,
        //                         "y": 27.8064624
        //                     },
        //                     "instruction": "Turn <b>left</b> onto <b>38th Ave N</b><div style=\"font-size:0.9em\">Pass by Advance Auto Parts (on the left in 1.7&nbsp;mi)</div>"
        //                 },
        //                 {
        //                     "distance": 448,
        //                     "duration": 65,
        //                     "startPoint": {
        //                         "x": -82.6877497,
        //                         "y": 27.8064624
        //                     },
        //                     "endPoint": {
        //                         "x": -82.6877397,
        //                         "y": 27.8104953
        //                     },
        //                     "instruction": "Turn <b>left</b> onto <b>40th St N</b><div style=\"font-size:0.9em\">Destination will be on the left</div>"
        //                 }
        //             ]
        //         },
        //         {
        //             "distance": 6099,
        //             "duration": 623,
        //             "startPoint": {
        //                 "x": -82.6877397,
        //                 "y": 27.8104953
        //             },
        //             "endPoint": {
        //                 "x": -82.6971362,
        //                 "y": 27.7693274
        //             },
        //             "steps": [
        //                 {
        //                     "distance": 448,
        //                     "duration": 58,
        //                     "startPoint": {
        //                         "x": -82.6877397,
        //                         "y": 27.8104953
        //                     },
        //                     "endPoint": {
        //                         "x": -82.6877497,
        //                         "y": 27.8064624
        //                     },
        //                     "instruction": "Head <b>south</b> on <b>40th St N</b> toward <b>42nd Ave N</b>"
        //                 },
        //                 {
        //                     "distance": 1205,
        //                     "duration": 97,
        //                     "startPoint": {
        //                         "x": -82.6877497,
        //                         "y": 27.8064624
        //                     },
        //                     "endPoint": {
        //                         "x": -82.69999539999999,
        //                         "y": 27.8064775
        //                     },
        //                     "instruction": "Turn <b>right</b> onto <b>38th Ave N</b>"
        //                 },
        //                 {
        //                     "distance": 1398,
        //                     "duration": 126,
        //                     "startPoint": {
        //                         "x": -82.69999539999999,
        //                         "y": 27.8064775
        //                     },
        //                     "endPoint": {
        //                         "x": -82.7003615,
        //                         "y": 27.7941137
        //                     },
        //                     "instruction": "Turn <b>left</b> onto <b>49th St N</b><div style=\"font-size:0.9em\">Pass by 7-Eleven (on the right in 0.5&nbsp;mi)</div>"
        //                 },
        //                 {
        //                     "distance": 2700,
        //                     "duration": 289,
        //                     "startPoint": {
        //                         "x": -82.7003615,
        //                         "y": 27.7941137
        //                     },
        //                     "endPoint": {
        //                         "x": -82.699845,
        //                         "y": 27.7700581
        //                     },
        //                     "instruction": "At the traffic circle, take the <b>2nd</b> exit and stay on <b>49th St N</b>"
        //                 },
        //                 {
        //                     "distance": 266,
        //                     "duration": 26,
        //                     "startPoint": {
        //                         "x": -82.699845,
        //                         "y": 27.7700581
        //                     },
        //                     "endPoint": {
        //                         "x": -82.6971365,
        //                         "y": 27.7700642
        //                     },
        //                     "instruction": "Turn <b>left</b> onto <b>1st Ave S</b>"
        //                 },
        //                 {
        //                     "distance": 82,
        //                     "duration": 27,
        //                     "startPoint": {
        //                         "x": -82.6971365,
        //                         "y": 27.7700642
        //                     },
        //                     "endPoint": {
        //                         "x": -82.6971362,
        //                         "y": 27.7693274
        //                     },
        //                     "instruction": "Turn <b>right</b> onto <b>47th St S</b><div style=\"font-size:0.9em\">Destination will be on the right</div>"
        //                 }
        //             ]
        //         }
        //     ],
        //     "distance": 27038,
        //     "duration": 2591
        // })
    }
}
