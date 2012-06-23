Tick-tock
==========
Tick-tock is a privacy-aware, personally-controlled and open source web app project for learning that provide a dairy service.

It's based on Rails 3.2 and MongoDB.

##Development Installation

### Step 1: Clone a Tick-tock repository.

### Step 2: Prepare
```
  bundle install
  rake db:mongoid:create_indexes
  rake db:seed
```

### Step 3: Run the development server
```
  rails s
```

then visit 'http://localhost:3000' in your browser.

##Inspiration
User's every dairy has equal value.

Most of dairy apps using timeline or calendar to organize user's dairies, that made
 nearest has great chance be reviewed that made older's value lower.

Tick-tock will display dairies randomly that keep every dairy's value.

##Features
- Support rich-text, camera, sound record and image.
- User needs choose a color to present his mood, maybe it's useful to datamining.
- Support Oauth, can share to SNS.
- *Location.
- *Mobile native client.
- Not think out yet. :-)

##Contributing
Fork is welcome, hoping you can pull your changes to make tick-tock better.

##License
Tick-tock is copyright Jasl 2012, and files herein are licensed
under the Affero General Public License version 3, the text of which can
be found in GNU-AGPL-3.0, or any later version of the AGPL, unless otherwise
noted.  Components of Tick-tock, including Rails, JQuery, and Devise, are
licensed under the MIT/X11 license.  Twitter Bootstrap is licensed under
 the Apache License v2.0.  All unmodified files from these
and other sources retain their original copyright and license notices: see
the relevant individual files.

In addition, as a special exception, the copyright holders give
permission to link the code of portions of this program with the
OpenSSL library under certain conditions as described in each
individual source file, and distribute linked combinations
including the two.

You must obey the GNU Affero General Public License V3 or later in all respects
for all of the code used other than OpenSSL or the components mentioned
above.  If you modify file(s) with this exception, you may extend this
exception to your version of the file(s), but you are not obligated to
do so.  If you do not wish to do so, delete this exception statement from your
version.  If you delete this exception statement from all source files in the
program, then also delete it here.

