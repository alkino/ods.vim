autocmd BufReadPre *.ods call OpenOds()

function! OpenOds()
python << EOF
import vim
import datetime
from lpod import document
currfile = vim.eval("expand('%:p')")
currbuf = vim.current.buffer
doc = document.odf_get_document(currfile)
for table in doc.get_body().get_tables():
    vim.command('tabnew')
    vim.command('setlocal nowrap nocursorcolumn')
    height = table.get_height()
    for i in xrange(height):
        values = table.get_row_values(i)
        line = list()
        values = ["" if x is None else x for x in values]
        for x in values:
          try:
            line.append(unicode(x))
          except:
            try:
              line.append(str(x))
            except:
              line.append("##Error")

        line = [x if len(x) < 10 else x[0:9]+">" for x in line]
        line = ["%-10s" % x for x in line]
        line = " ".join(line)
        vim.current.buffer.append(line)
EOF
endfunction
