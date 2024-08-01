
export function AdminPanel() {
  return `
        <div id="admin-panel">
            <h1>Goalzify Admin Panel</h1>
            <nav>
                <ul>
                    <li><a href="#" onclick="window.showSection('dashboard')">Dashboard</a></li>
                    <li><a href="#" onclick="window.showSection('addContent')">Add Content</a></li>
                    <li><a href="#" onclick="window.showSection('contentList')">Content List</a></li>
                    <li><a href="#" onclick="window.showSection('users')">Users</a></li>
                </ul>
            </nav>
            <div id="dashboard" class="section">
                <h2>Dashboard</h2>
                <p>Welcome to the admin dashboard.</p>
            </div>
            <div id="addContent" class="section" style="display:none;">
            <h2>Add New Content</h2>
            <form id="addContentForm">
            <div class="form-group">
                <label for="title">Title</label>
                <input type="text" id="title" placeholder="Enter content title" required>
            </div>
            <div class="form-group">
                <label for="content">Content</label>
                <textarea id="content" placeholder="Enter your content here" rows="6" required></textarea>
            </div>
            <div class="form-group">
                <label for="category">Category</label>
                <select id="category">
                    <option value="">Select a category</option>
                    <option value="motivation">Motivation</option>
                    <option value="productivity">Productivity</option>
                    <option value="health">Health</option>
                    <option value="career">Career</option>
                </select>
            </div>
             <div class="form-group">
        <label for="image">Image</label>
        <input type="file" id="image" accept="image/*">
    </div>
                <button type="submit" class="btn-primary" onclick="window.addContent(event)">Add Content</button>
                </form>
            </div>
                <div id="contentList" class="section" style="display:none;">
                    <h2>Content List</h2>
                    <div id="contentListItems"></div>
                </div>
                <div id="users" class="section" style="display:none;">
                    <h2>Users</h2>
                    <div id="userList"></div>
                </div>
                <button onclick="window.logout()">Logout</button>
        </div>
    `;
}

export function setupAdminFunctions(firebase) {
  window.showSection = function (sectionId) {
    document.querySelectorAll(".section").forEach((section) => {
      section.style.display = "none";
    });
    document.getElementById(sectionId).style.display = "block";
    if (sectionId === "contentList") {
      loadContent();
    } else if (sectionId === "users") {
      loadUsers();
    }
  };

  window.addContent = function (event) {
    event.preventDefault();

    const title = document.getElementById('title').value;
    const content = document.getElementById('content').value;
    const category = document.getElementById('category').value;
    const imageFile = document.getElementById('image').files[0];

    const user = firebase.auth.currentUser;
    if (!user) {
      alert("You must be logged in to add content.");
      return;
    }

    if (!title || !content) {
      alert("Please fill in all required fields.");
      return;
    }

    if (imageFile) {
      const storageRef = firebase.ref(firebase.storage, 'content_images/' + imageFile.name);
      firebase.uploadBytes(storageRef, imageFile)
        .then((snapshot) => {
          console.log('Uploaded a blob or file!', snapshot);
          return firebase.getDownloadURL(snapshot.ref);
        })
        .then((imageUrl) => {
          console.log('Got download URL:', imageUrl);
          return saveContent(title, content, category, imageUrl);
        })
        .catch((error) => {
          console.error("Error in addContent:", error);
          alert("Error adding content: " + error.message);
        });
    } else {
      saveContent(title, content, category)
        .catch((error) => {
          console.error("Error in addContent:", error);
          alert("Error adding content: " + error.message);
        });
    }
  }
  // Save content to Firestore

  function saveContent(title, content, category, imageUrl = null) {
    firebase.addDoc(firebase.collection(firebase.db, "content"), {
      title: title,
      content: content,
      category: category,
      imageUrl: imageUrl,
      timestamp: firebase.serverTimestamp()
    })
      .then(() => {
        alert("Content added successfully");
        document.getElementById('addContentForm').reset();
        loadContent();
      })
      .catch((error) => {
        alert("Error adding content: " + error);
      });
  }

  window.loadContent = function () {
    const contentList = document.getElementById('contentListItems');
    contentList.innerHTML = 'Loading content...';
    const q = firebase.query(firebase.collection(firebase.db, "content"), firebase.orderBy("timestamp", "desc"));
    firebase.getDocs(q)
      .then((querySnapshot) => {
        contentList.innerHTML = '';
        querySnapshot.forEach((doc) => {
          const data = doc.data();
          contentList.innerHTML += `
                    <div class="content-item">
                        <h3>${data.title}</h3>
                        <p>${data.content}</p>
                        <button onclick="window.editContent('${doc.id}')">Edit</button>
                        <button onclick="window.deleteContent('${doc.id}')">Delete</button>
                    </div>
                `;
        });
      });
  }

  // Edit content in Firestore
  window.editContent = function (docId) {
    const docRef = doc(db, "content", docId);
    getDocs(docRef).then((doc) => {
      if (doc.exists()) {
        const data = doc.data();
        const newTitle = prompt("Edit title:", data.title);
        const newContent = prompt("Edit content:", data.content);
        if (newTitle !== null && newContent !== null) {
          updateDoc(docRef, {
            title: newTitle,
            content: newContent,
          })
            .then(() => {
              alert("Content updated successfully");
              loadContent();
            })
            .catch((error) => {
              alert("Error updating content: " + error);
            });
        }
      }
    });
  };
  window.deleteContent = function (docId) {
    if (confirm("Are you sure you want to delete this content?")) {
      deleteDoc(doc(db, "content", docId))
        .then(() => {
          alert("Content deleted successfully");
          loadContent();
        })
        .catch((error) => {
          alert("Error deleting content: " + error);
        });
    }
  };

  window.loadUsers = function () {
    const userList = document.getElementById("userList");
    userList.innerHTML = "Loading users...";
    getDocs(collection(db, "users")).then((querySnapshot) => {
      userList.innerHTML = "";
      querySnapshot.forEach((doc) => {
        const data = doc.data();
        userList.innerHTML += `
                        <div class="user-item">
                            <p>Email: ${data.email}</p>
                            <p>Role: ${data.role || "User"}</p>
                        </div>
                    `;
      });
    });
  };

  window.logout = function () {
    firebase.auth().signOut();
  };

  // Firebase'in yüklendiğinden emin olduktan sonra içeriği yükle
  firebase.auth.onAuthStateChanged(function (user) {
    if (user) {
      loadContent();
    }
  });
}
