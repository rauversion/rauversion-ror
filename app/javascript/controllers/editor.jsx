import { Controller } from "@hotwired/stimulus";
import React from 'react';
import { createRoot } from 'react-dom/client';
import Dante, {
  defaultTheme, 
  darkTheme,
  ImageBlockConfig,
  CodeBlockConfig,
  DividerBlockConfig,
  PlaceholderBlockConfig,
  EmbedBlockConfig,
  VideoBlockConfig,
  GiphyBlockConfig,
  VideoRecorderBlockConfig,
  SpeechToTextBlockConfig,
} from 'dante3/package/esm';
import { DirectUpload } from "@rails/activestorage";

import { get, post, put, patch, destroy } from '@rails/request.js'




export default class extends Controller {
  connect() {
    const wrapper = this.element;
    const root = createRoot(wrapper);
    this.locked = false
    
    root.render(
      <Dante 
        theme={darkTheme}
        content={JSON.parse(wrapper.dataset.field)}
        widgets={[
          ImageBlockConfig({
            options: {
              upload_handler: (file, ctx) => {
                console.log("UPLOADED FILE!!!!", file)
                
                this.upload(file, (blob)=>{
                  console.log(blob)
                  console.log(ctx)
                  ctx.updateAttributes({
                    url: blob.service_url
                  })
                })
              }
            }
          }),
          CodeBlockConfig(),
          DividerBlockConfig(),
          PlaceholderBlockConfig(),
          EmbedBlockConfig({
            options: {
              endpoint: "/oembed?url=",
              placeholder: "Paste a link to embed content from another site (e.g. Twitter) and press Enter"
            },
          }),
          VideoBlockConfig({
            options: {
              endpoint: "/oembed?url=",
              placeholder:
                "Paste a YouTube, Vine, Vimeo, or other video link, and press Enter",
              caption: "Type caption for embed (optional)",
            },
          }),
          GiphyBlockConfig(),
          VideoRecorderBlockConfig({
            options: {
              upload_handler: (file, ctx) => {
                console.log("UPLOADED VIDEO FILE!!!!", file)
                
                this.upload(file, (blob)=>{
                  console.log(blob)
                  console.log(ctx)
                  ctx.updateAttributes({
                    url: blob.service_url
                  })
                })
              }
            }
          }),
          SpeechToTextBlockConfig(),
        ]}
        onUpdate={(editor)=>{
          console.log(editor.getJSON())
          //wrapper.dataset.field = editor.getHTML()
          if(!this.locked && !this.element.dataset.id && editor.state.doc.textContent.length > 0 ){
            this.createArticle(editor.getJSON())
            this.locked = false
          }

          if(!this.locked && this.element.dataset.id){
            this.updateArticle(editor.getJSON())
            this.locked = false
          }
          // this.pushEvent("update-content", {content: editor.getJSON() } )
      }}/>
    );
  }

  async createArticle (body) {
    this.locked = true
    const response = await post('/articles', { 
      responseKind: "turbo-stream", 
      body: { post: {body: body } } 
    })
    
    if (response.redirected) {
      Turbo.visit(response.response.url);
    }
  }

  async updateArticle (body) {
    this.locked = true
    const id = this.element.dataset.id
    const response = await put(`/articles/${id}`, { 
      responseKind: "turbo-stream", 
      body: {
        post: { body: body, id: id }
      } 
    })
    
    if (response.redirected) {
      Turbo.visit(response.response.url);
    }
  }

  upload(file, cb){
    if(!file) return
    const url = '/api/v1/direct_uploads'
    const upload = new DirectUpload(file, url)
  
    upload.create((error, blob) => {
      if (error) {
        // Handle the error
      } else {
        cb(blob)
      }
    })
  }

  updateContent(data) {
    // You will need to implement this method to handle the 
    // "update-content" event. This may involve making an AJAX 
    // request to your server with the updated content.
  }

  disconnect() {
    // Cleanup when the controller is disconnected
  }
}