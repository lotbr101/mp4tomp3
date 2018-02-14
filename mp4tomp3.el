;;; package --- Summary
;;; Commentary:

;;; Code:
(require 'cl)

(defun mp4tomp3-string->command (fileName)
  "Convert file name to convert commans.
FILENAME - name of the file for processing"
  (let ((wavname (format "%s.wav" (file-name-sans-extension fileName))))
    (concat (format "mplayer -vo null -ao pcm:file=\"%s\" \"%s\"\n" wavname fileName)
            (format "lame \"%s\" --preset standard \n" wavname)
            ;;; (format "rm \"%s\"\n" wavname)
            )))

(defun mp4tomp3-files (directory)
  "Return list of files for processing.
DIRECTORY - directory with files for processing"
  (cl-remove-if (lambda (x)
                  (cond ((string= ".." x)t)
                        ((string= "." x) t)
                        (t nil)
                        ))
                (directory-files directory)))

(defun mp4tomp3 (dirSrc)
  "Create batch file for procesing to mp3.
DIRSRC - source directory"
  (interactive
   (list
    (read-directory-name "Open directory:")))
  (let ((destFile (concat dirSrc "process.bat"))
        (cmdList (cl-mapcar 'mp4tomp3-string->command (mp4tomp3-files dirSrc))))
    (with-temp-buffer (write-file destFile))
    (with-current-buffer (find-file  destFile)
      (cl-mapcar 'insert cmdList)
      (save-buffer)
      (kill-buffer))))


  
(provide 'mp4tomp3)
;;; mp4tomp3 ends here
