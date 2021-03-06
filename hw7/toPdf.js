// 1)

/*
* These insert statements lay out the schema for my database. I did not edit the schema very much to suit this data, as 
* it did not prove necessary to do so. Things I did change include: changing active and available from either a Y or N 
* to a boolean value (true/false), separating the author's name in book to first and last name, and adding multiple 
* addresses for each publisher, multiple subjects for each book and multiple notes for each book to accommodate the 
* data given. 
*/

// 2)

db.AUTHOR.insert([
    {
        first_name: "Danielle",
        last_name: "Steele",
        dob: new Date('Mar 2, 1967')
    },
    {
        first_name: "Donald",
        last_name: "Knuth",
        dob: new Date('Jan 10, 1938')
    },
    {
        first_name: "Brian",
        last_name: "Kernigan",
        dob: new Date('Feb 28, 1951')
    },
    {
        first_name: "Herbert",
        last_name: "Schild",
        dob: new Date('Feb 28, 1951')
    },
    {
        first_name: "Larry",
        last_name: "Wall",
        dob: new Date('Sep 27, 1957')
    },
])

db.USER.insert([
    {
        username: "ashley",
        password: "ashley",
        active: true,
        address: {
            street: "170 Commonwealth Avenue",
            city: "Boston",
            zip: 2140,
            state: "Massachusetts",
            country: "US"
        },
        date_of_creation: new Date('Apr 20, 2014')
    },
    {
        username: "ashley",
        password: "ashley",
        active: true,
        address: {
            street: "10 Park Avenue",
            city: "Boston",
            zip: 2140,
            state: "Massachusetts",
            country: "US"
        },
        date_of_creation: new Date('Apr 20, 2014')
    },
    {
        username: "jason",
        password: "jason",
        active: true,
        address: {
            street: "70 Peterbourough Street",
            city: "Boston",
            zip: 2145,
            state: "Massachusetts",
            country: "US"
        },
        date_of_creation: new Date('Sep 20, 2015')
    },
    {
        username: "jason",
        password: "jason",
        active: true,
        address: {
            street: "2 Downtown",
            city: "Boston",
            zip: 2143,
            state: "Massachusetts",
            country: "US"
        },
        date_of_creation: new Date('Sep 20, 2015')
    },
    {
        username: "admin",
        password: "admin",
        active: true,
        address: {
            street: "10 Geng Road",
            city: "Palo Alto",
            zip: 94303,
            state: "California",
            country: "US"
        },
        date_of_creation: new Date('Jan 4, 2014')
    },
    {
        username: "jen",
        password: "jen",
        active: false,
        address: {
            street: "Geng Road",
            city: "Palo Alto",
            zip: 94303,
            state: "California",
            country: "US"
        },
        date_of_creation: new Date('Nov 25, 2013')
    }
])

db.BOOK.insert([
    {
        title: "Southern Lights",
        author: {
            first_name: "Danielle",
            last_name: "Steele"
        },
        isbn: "303041974",
        publisher: {
            p1: {
                name: "Random House",
                date: new Date('Apr 23, 2002'),
                addresses: {
                    a1: {
                        street: "1475 Broadway",
                        city: "New York",
                        zip: 10019,
                        state: "New York",
                        country: "US"
                    },
                    a2: {
                        street: "375 Hudson Street",
                        city: "New York",
                        zip: 10014,
                        state: "New York",
                        country: "US"
                    }
                }
            },
            p2: {
                name: "Penguin Publishers",
                date: new Date('Jan 19, 1998'),
                addresses: {
                    a1: {
                        street: "140 Broadway",
                        city: "New York",
                        zip: 10013,
                        state: "New York",
                        country: "US"
                    }
                }
            },
        },
        available: true,
        pages: 2042,
        summary: "Danielle Steel sweeps us from a Manhattan courtroom to the Deep South in her powerful new novel—at once a behind-closed-doors look into the heart of a family and a tale of crime and punishment.",
        subjects: {
            s1: "Fiction",
            s2: "Romance"
        },
        notes: {
            n1: {
                user: "jason",
                body: "Nice book. Must Read"
            },
            n2: {
                user: "jen",
                body: "Nice book. I have been traveling a lot, so I listened to the audio of this book. I really enjoyed it."
            }
        },
        language: "English"
    },
    {
        title: "Concrete Mathematics",
        author: {
            first_name: "Donald",
            last_name: "Knuth"
        },
        isbn: "0-203-03803-1",
        publisher: {
            p3: {
                name: "Addison-Wesley",
                date: new Date('Mar 1, 1994'),
                addresses: {
                    a1: {
                        street: "75 Arlington Street",
                        city: "Boston",
                        zip: 2116,
                        state: "Massachussetts",
                        country: "US"
                    }
                }
            },
        },
        available: true,
        pages: 3524,
        summary: "Concrete Mathematics: A Foundation for Computer Science, by Ronald Graham, Donald Knuth, and Oren Patashnik, is a textbook that is widely used in computer-science departments",
        subjects: {
            s1: "Mathematics",
            s2: "Algebra"
        },
        notes: {},
        language: "English"
    }
])

// 3) 
db.BOOK.find({})

// 4) 
db.BOOK.find({ author: { first_name: "Danielle", last_name: "Steele" } })

// 5) 
db.USER.find({ $and: [{ "address.city": "Boston" }, { date_of_creation: { $gt: new Date('Dec 15, 2014') } }] })

// 6) 
db.BOOK.find({'publisher.p2': {$exists: true}})

// 7) 
db.BOOK.find({'notes': {$exists: true}})

// 8)
/* I agree with craigslist's decision to choose to switch over to MongoDB, largely for the reasons the article provided. 
* Due to the lack of flexibility of a mySQL database, introducing a new live schema meant a lot of work was needed to be
* done to incorporate that into the archived schema, a huge hassle for a major company trying to push new features. On 
* top of that, the operational complexity of mySQL for a long and changing database such as this must have been 
* astronomical. Meanwhile MongoDB comparatively was better for a variety of reasons. Its flexibilility meant that changes
* on the live schema were easy to incorporate, and it proved to be more easily scalable for the needs that craigslist has. 
* Finally, simply due to the fact that MongoDB is relatively similar to SQL, it begs the question as to why not switch if
* MongoDB appears to be such a better option and is still easy to pick up and use?

// 9)
