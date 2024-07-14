
import { Controller } from '@hotwired/stimulus';


import Document from '@tiptap/extension-document'
import Paragraph from '@tiptap/extension-paragraph'
import Text from '@tiptap/extension-text'
import { Editor } from '@tiptap/core'
import Heading from '@tiptap/extension-heading'
import Bold from '@tiptap/extension-bold'
import Italic from '@tiptap/extension-italic'
import Link from '@tiptap/extension-link'
import ListItem from '@tiptap/extension-list-item'
import OrderedList from '@tiptap/extension-ordered-list'
import BulletList from "@tiptap/extension-bullet-list"
import History from '@tiptap/extension-history'
import { generateHTML, generateJSON } from '@tiptap/html'

export default class extends Controller {

  static targets = ["editor", "linkField", "linkWrapper", "textInput"]
  
  initialize(){
    
    const textInput = this.textInputTarget

    const richExtensions = [
      Document,
      Paragraph,
      Text,
      Bold,
      Italic,
      Link,
      OrderedList, 
      ListItem,
      BulletList,
      History.configure({
        depth: 10,
      }),
      Heading.configure({
        levels: [1, 2, 3],
      })
    ]

    const plainExtensions = [
      Document,
      Paragraph,
      Text,
    ]

    const extensions = this.element.dataset.plain ? 
      plainExtensions : richExtensions
  
    this.editor = new Editor({
      element: this.editorTarget,
      extensions: extensions,
        // all your other extensions
      onBeforeCreate({ editor }) {
        // Before the view is created.
      },
      onCreate({ editor }) {
        // The editor is ready.
        editor.commands.insertContent(textInput.value)
      },
      onUpdate({ editor }) {
        // The content has changed.
        console.log("updated", editor.state.toJSON())

        const html = generateHTML(editor.state.toJSON().doc, [
          Document,
          Paragraph,
          Text,
          Bold,
          Italic,
          Link,
          OrderedList, 
          ListItem,
          BulletList,
          History.configure({
            depth: 10,
          }),
          Heading.configure({
            levels: [1, 2, 3],
          }),
        ])

        console.log("HTML", html)
        textInput.value = html
      },
      onSelectionUpdate({ editor }) {
        // The selection has changed.
      },
      onTransaction({ editor, transaction }) {
        // The editor state has changed.
      },
      onFocus({ editor, event }) {
        // The editor is focused.
      },
      onBlur({ editor, event }) {
        // The editor isn’t focused anymore.
      },
      onDestroy() {
        // The editor is being destroyed.
      },
    })

    //this.editor.insertContent(textInput.value)
    //this.editor.commands.setContent(this.textInputTarget.value)
    window.ed = this.editor
  }

  toggleBold(e){
    e.preventDefault()
    this.editor.commands.toggleBold()
  }

  toggleItalic(e){
    e.preventDefault()
    this.editor.commands.toggleItalic()
  }

  toggleHeading(e) {
    // Check if the event is from a click or a specific key press on the button
    if (e.type === 'click') { // || (e.type === 'keydown' && e.key === 'Enter' && e.target.matches('[data-action="toggleHeading"]'))) {
      e.preventDefault();
      this.editor.commands.toggleHeading({ level: parseInt(e.currentTarget.dataset.level) });
    }
  }

  toggleOrderedList(e){
    e.preventDefault()
    this.editor.commands.toggleOrderedList()
  }

  toggleBulletList(e){
    e.preventDefault()
    this.editor.commands.toggleBulletList()
  }

  insert(e){
    e.preventDefault()
    this.editor.commands.insertContent(e.currentTarget.dataset.value)
  }

  setLink(e){
    e.preventDefault()
    this.editor.commands.toggleLink({ href: this.linkFieldTarget.value, target: '_blank' })
  }


  toggleLink(e){
    e.preventDefault()
    this.editor.commands.toggleLink({ href: this.linkFieldTarget.value, target: '_blank' })
  }

  openLinkPrompt(e){
    e.preventDefault()
    this.linkWrapperTarget.classList.toggle("hidden")
  }

  disconnect(){
    this.editor && this.editor.cleanup()
  }
}