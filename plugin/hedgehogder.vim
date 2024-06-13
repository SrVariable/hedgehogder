let s:asciiart = [
			\"       #+#+#+#+#+#+#+#+#+#+#+#+           ",
			\"    #+#+#+#+#+#+#+#+#+#+#+#+#+#+#+        ",
			\"  +#+#+#+#+#+#+#+#+#+#+#+#+#+#···#+#      ",
			\" +#+#+#+#+#+#+#+#+#+#+#+#+#+·······+#     ",
			\"+#+#+#+#+#+#+#+#+#+#+#+#+#+·····@···+#    ",
			\"#+#+#+#+#+#+#+#+#+#+#+#+#+#+··········#*  ",
			\"   ###################################    ",
			\"     ##      ##      ##      ##           ",
			\"    ###     ###     ###     ###           ",
			\]

let s:start		= '/*'
let s:end		= '*/'
let s:fill		= '*'
let s:length	= 80
let s:margin	= 5

let s:types		= {
			\'\.c$\|\.h$\|\.cc$\|\.hh$\|\.cpp$\|\.hpp$\|\.php':
			\['/*', '*/', '*'],
			\'\.htm$\|\.html$\|\.xml$':
			\['<!--', '-->', '*'],
			\'\.js$':
			\['//', '//', '*'],
			\'\.tex$':
			\['%', '%', '*'],
			\'\.ml$\|\.mli$\|\.mll$\|\.mly$':
			\['(*', '*)', '*'],
			\'\.vim$\|\vimrc$':
			\['"', '"', '*'],
			\'\.el$\|\emacs$':
			\[';', ';', '*'],
			\'\.f90$\|\.f95$\|\.f03$\|\.f$\|\.for$':
			\['!', '!', '/']
			\}

function! s:filetype()
	let l:f = s:filename()

	let s:start	= '#'
	let s:end	= '#'
	let s:fill	= '*'

	for type in keys(s:types)
		if l:f =~ type
			let s:start	= s:types[type][0]
			let s:end	= s:types[type][1]
			let s:fill	= s:types[type][2]
		endif
	endfor

endfunction

function! s:ascii(n)
	return s:asciiart[a:n - 3]
endfunction

function! s:textline(left, right)
	let l:left = strpart(a:left, 0, s:length - s:margin + 8 - strlen(a:right))

	return s:start . repeat(' ', s:margin - strlen(s:start)) . l:left . repeat(' ', s:length - s:margin * 2 + 3 - strlen(l:left) - strlen(a:right)) . a:right . repeat(' ', 2 - strlen(s:end)) . s:end
endfunction

function! s:line(n)
	if a:n == 1 || a:n == 11 " top and bottom line
		return s:start . ' ' . repeat(s:fill, s:length - strlen(s:start) - strlen(s:end) - 2) . ' ' . s:end
	elseif a:n == 2 || a:n == 3 || a:n == 10 " empty with ascii
		return s:textline('', s:ascii(a:n+1))
	elseif a:n == 5 || a:n == 7
		return s:textline(repeat(' ', 31), s:ascii(a:n+1))
	elseif a:n == 4 " filename
		return s:textline(strpart(s:filename(), 0, 28) . repeat(' ', 4 + 27 - strlen(strpart(s:filename(), 0, 28))), s:ascii(a:n+1))
	elseif a:n == 6 " author
		return s:textline("By: " . s:user() . repeat(' ', 17), s:ascii(a:n+1))
	elseif a:n == 8 " created
		return s:textline("Created: " . s:date(), s:ascii(a:n+1))
	elseif a:n == 9 " updated
		return s:textline("Updated: " . s:date(), s:ascii(a:n+1))
	endif
endfunction

function! s:user()
	return "SrVariable"
endfunction

function! s:filename()
	let l:filename = expand("%:t")
	if strlen(l:filename) == 0
		let l:filename = "< new >"
	endif
	return l:filename
endfunction

function! s:date()
	return strftime("%Y/%m/%d %H:%M:%S")
endfunction

function! s:insert()
	let l:line = 11

	" empty line after header
	call append(0, "")

	" loop over lines
	while l:line > 0
		call append(0, s:line(l:line))
		let l:line = l:line - 1
	endwhile
endfunction

function! s:update()
	call s:filetype()
	if getline(9) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "Updated: "
		if &mod
			call setline(9, s:line(9))
		endif
		call setline(4, s:line(4))
		return 0
	endif
	return 1
endfunction

function! s:hedgehogder()
	if s:update()
		call s:insert()
	endif
endfunction

command! Hedgehoger call s:hedgehogder ()
"autocmd BufWritePre * call s:update ()
