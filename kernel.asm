
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 c5 10 80       	mov    $0x8010c5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 30 10 80       	mov    $0x80103060,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 14 c6 10 80       	mov    $0x8010c614,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 00 77 10 80       	push   $0x80107700
80100055:	68 e0 c5 10 80       	push   $0x8010c5e0
8010005a:	e8 01 49 00 00       	call   80104960 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 dc 0c 11 80       	mov    $0x80110cdc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 2c 0d 11 80 dc 	movl   $0x80110cdc,0x80110d2c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 30 0d 11 80 dc 	movl   $0x80110cdc,0x80110d30
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 77 10 80       	push   $0x80107707
80100097:	50                   	push   %eax
80100098:	e8 83 47 00 00       	call   80104820 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 0d 11 80       	mov    0x80110d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 80 0a 11 80    	cmp    $0x80110a80,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 e0 c5 10 80       	push   $0x8010c5e0
801000e8:	e8 f3 49 00 00       	call   80104ae0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 30 0d 11 80    	mov    0x80110d30,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 0d 11 80    	mov    0x80110d2c,%ebx
80100126:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 0c 11 80    	cmp    $0x80110cdc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 c5 10 80       	push   $0x8010c5e0
80100162:	e8 39 4a 00 00       	call   80104ba0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 46 00 00       	call   80104860 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 0f 21 00 00       	call   801022a0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 0e 77 10 80       	push   $0x8010770e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 39 47 00 00       	call   80104900 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 c3 20 00 00       	jmp    801022a0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 1f 77 10 80       	push   $0x8010771f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 f8 46 00 00       	call   80104900 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 a8 46 00 00       	call   801048c0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
8010021f:	e8 bc 48 00 00       	call   80104ae0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 30 0d 11 80       	mov    0x80110d30,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 dc 0c 11 80 	movl   $0x80110cdc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 30 0d 11 80       	mov    0x80110d30,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 30 0d 11 80    	mov    %ebx,0x80110d30
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 e0 c5 10 80 	movl   $0x8010c5e0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 2b 49 00 00       	jmp    80104ba0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 26 77 10 80       	push   $0x80107726
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 b6 15 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 2a 48 00 00       	call   80104ae0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002cb:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 c0 0f 11 80       	push   $0x80110fc0
801002e5:	e8 06 3e 00 00       	call   801040f0 <sleep>
    while(input.r == input.w){
801002ea:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 b1 36 00 00       	call   801039b0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 8d 48 00 00       	call   80104ba0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 64 14 00 00       	call   80101780 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 c0 0f 11 80    	mov    %edx,0x80110fc0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 40 0f 11 80 	movsbl -0x7feef0c0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 36 48 00 00       	call   80104ba0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 0d 14 00 00       	call   80101780 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 c0 0f 11 80       	mov    %eax,0x80110fc0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 0e 25 00 00       	call   801028c0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 2d 77 10 80       	push   $0x8010772d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 87 80 10 80 	movl   $0x80108087,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 9f 45 00 00       	call   80104980 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 41 77 10 80       	push   $0x80107741
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 c1 5e 00 00       	call   801062f0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 d6 5d 00 00       	call   801062f0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ca 5d 00 00       	call   801062f0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 be 5d 00 00       	call   801062f0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 2a 47 00 00       	call   80104c90 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 75 46 00 00       	call   80104bf0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 45 77 10 80       	push   $0x80107745
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 70 77 10 80 	movzbl -0x7fef8890(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 08 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 7c 44 00 00       	call   80104ae0 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 04 45 00 00       	call   80104ba0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 db 10 00 00       	call   80101780 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb 58 77 10 80       	mov    $0x80107758,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 1e 43 00 00       	call   80104ae0 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 73 43 00 00       	call   80104ba0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 5f 77 10 80       	push   $0x8010775f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 64 42 00 00       	call   80104ae0 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 c0 0f 11 80    	sub    0x80110fc0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d c8 0f 11 80    	mov    %ecx,0x80110fc8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 40 0f 11 80    	mov    %bl,-0x7feef0c0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 c0 0f 11 80       	mov    0x80110fc0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 c8 0f 11 80    	cmp    %eax,0x80110fc8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100925:	39 05 c4 0f 11 80    	cmp    %eax,0x80110fc4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 40 0f 11 80 0a 	cmpb   $0xa,-0x7feef0c0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
8010096f:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
80100985:	3b 05 c4 0f 11 80    	cmp    0x80110fc4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 c8 0f 11 80       	mov    %eax,0x80110fc8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 cc 41 00 00       	call   80104ba0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 40 0f 11 80 0a 	movb   $0xa,-0x7feef0c0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 0c 3a 00 00       	jmp    80104410 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 c8 0f 11 80       	mov    0x80110fc8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 c4 0f 11 80       	mov    %eax,0x80110fc4
          wakeup(&input.r);
80100a1b:	68 c0 0f 11 80       	push   $0x80110fc0
80100a20:	e8 eb 38 00 00       	call   80104310 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 68 77 10 80       	push   $0x80107768
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 17 3f 00 00       	call   80104960 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 8c 19 11 80 40 	movl   $0x80100640,0x8011198c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 88 19 11 80 90 	movl   $0x80100290,0x80111988
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 de 19 00 00       	call   80102450 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 1b 2f 00 00       	call   801039b0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 b0 22 00 00       	call   80102d50 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 a5 15 00 00       	call   80102050 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 18 03 00 00    	je     80100dce <exec+0x34e>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 bf 0c 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 ae 0f 00 00       	call   80101a80 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 3d 0f 00 00       	call   80101a20 <iunlockput>
    end_op();
80100ae3:	e8 d8 22 00 00       	call   80102dc0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 4f 69 00 00       	call   80107460 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 be 02 00 00    	je     80100ded <exec+0x36d>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 08 67 00 00       	call   80107280 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 02 66 00 00       	call   801071b0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 aa 0e 00 00       	call   80101a80 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 f0 67 00 00       	call   801073e0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 ff 0d 00 00       	call   80101a20 <iunlockput>
  end_op();
80100c21:	e8 9a 21 00 00       	call   80102dc0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 49 66 00 00       	call   80107280 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 a4 00 00 00    	je     80100ce8 <exec+0x268>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 a8 68 00 00       	call   80107500 <clearpteu>
  curproc->stackTop = sp;
80100c58:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c5e:	83 c4 10             	add    $0x10,%esp
80100c61:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  curproc->stackTop = sp;
80100c67:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c70:	8b 00                	mov    (%eax),%eax
80100c72:	85 c0                	test   %eax,%eax
80100c74:	0f 84 8f 00 00 00    	je     80100d09 <exec+0x289>
80100c7a:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c80:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c86:	eb 27                	jmp    80100caf <exec+0x22f>
80100c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8f:	90                   	nop
80100c90:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c93:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c9a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c9d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ca3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ca6:	85 c0                	test   %eax,%eax
80100ca8:	74 59                	je     80100d03 <exec+0x283>
    if(argc >= MAXARG)
80100caa:	83 ff 20             	cmp    $0x20,%edi
80100cad:	74 39                	je     80100ce8 <exec+0x268>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100caf:	83 ec 0c             	sub    $0xc,%esp
80100cb2:	50                   	push   %eax
80100cb3:	e8 38 41 00 00       	call   80104df0 <strlen>
80100cb8:	f7 d0                	not    %eax
80100cba:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cbc:	58                   	pop    %eax
80100cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cc3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc6:	e8 25 41 00 00       	call   80104df0 <strlen>
80100ccb:	83 c0 01             	add    $0x1,%eax
80100cce:	50                   	push   %eax
80100ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cd2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cd5:	53                   	push   %ebx
80100cd6:	56                   	push   %esi
80100cd7:	e8 84 69 00 00       	call   80107660 <copyout>
80100cdc:	83 c4 20             	add    $0x20,%esp
80100cdf:	85 c0                	test   %eax,%eax
80100ce1:	79 ad                	jns    80100c90 <exec+0x210>
80100ce3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ce7:	90                   	nop
    freevm(pgdir);
80100ce8:	83 ec 0c             	sub    $0xc,%esp
80100ceb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cf1:	e8 ea 66 00 00       	call   801073e0 <freevm>
80100cf6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cfe:	e9 ed fd ff ff       	jmp    80100af0 <exec+0x70>
80100d03:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d09:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d10:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d12:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d19:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d1d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d1f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d22:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d28:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d2a:	50                   	push   %eax
80100d2b:	52                   	push   %edx
80100d2c:	53                   	push   %ebx
80100d2d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d33:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d3a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d43:	e8 18 69 00 00       	call   80107660 <copyout>
80100d48:	83 c4 10             	add    $0x10,%esp
80100d4b:	85 c0                	test   %eax,%eax
80100d4d:	78 99                	js     80100ce8 <exec+0x268>
  for(last=s=path; *s; s++)
80100d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d52:	8b 55 08             	mov    0x8(%ebp),%edx
80100d55:	0f b6 00             	movzbl (%eax),%eax
80100d58:	84 c0                	test   %al,%al
80100d5a:	74 13                	je     80100d6f <exec+0x2ef>
80100d5c:	89 d1                	mov    %edx,%ecx
80100d5e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d60:	83 c1 01             	add    $0x1,%ecx
80100d63:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d65:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d68:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d6b:	84 c0                	test   %al,%al
80100d6d:	75 f1                	jne    80100d60 <exec+0x2e0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d6f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d75:	83 ec 04             	sub    $0x4,%esp
80100d78:	6a 10                	push   $0x10
80100d7a:	89 f8                	mov    %edi,%eax
80100d7c:	52                   	push   %edx
80100d7d:	83 c0 6c             	add    $0x6c,%eax
80100d80:	50                   	push   %eax
80100d81:	e8 2a 40 00 00       	call   80104db0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d86:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  curproc->threads = 1;  
80100d8c:	89 f8                	mov    %edi,%eax
80100d8e:	c7 87 84 00 00 00 01 	movl   $0x1,0x84(%edi)
80100d95:	00 00 00 
  oldpgdir = curproc->pgdir;
80100d98:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d9b:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d9d:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100da0:	89 c1                	mov    %eax,%ecx
80100da2:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100da8:	8b 40 18             	mov    0x18(%eax),%eax
80100dab:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dae:	8b 41 18             	mov    0x18(%ecx),%eax
80100db1:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100db4:	89 0c 24             	mov    %ecx,(%esp)
80100db7:	e8 64 62 00 00       	call   80107020 <switchuvm>
  freevm(oldpgdir);
80100dbc:	89 3c 24             	mov    %edi,(%esp)
80100dbf:	e8 1c 66 00 00       	call   801073e0 <freevm>
  return 0;
80100dc4:	83 c4 10             	add    $0x10,%esp
80100dc7:	31 c0                	xor    %eax,%eax
80100dc9:	e9 22 fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100dce:	e8 ed 1f 00 00       	call   80102dc0 <end_op>
    cprintf("exec: fail\n");
80100dd3:	83 ec 0c             	sub    $0xc,%esp
80100dd6:	68 81 77 10 80       	push   $0x80107781
80100ddb:	e8 d0 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100de0:	83 c4 10             	add    $0x10,%esp
80100de3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100de8:	e9 03 fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ded:	31 ff                	xor    %edi,%edi
80100def:	be 00 20 00 00       	mov    $0x2000,%esi
80100df4:	e9 1f fe ff ff       	jmp    80100c18 <exec+0x198>
80100df9:	66 90                	xchg   %ax,%ax
80100dfb:	66 90                	xchg   %ax,%ax
80100dfd:	66 90                	xchg   %ax,%ax
80100dff:	90                   	nop

80100e00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e0a:	68 8d 77 10 80       	push   $0x8010778d
80100e0f:	68 e0 0f 11 80       	push   $0x80110fe0
80100e14:	e8 47 3b 00 00       	call   80104960 <initlock>
}
80100e19:	83 c4 10             	add    $0x10,%esp
80100e1c:	c9                   	leave  
80100e1d:	c3                   	ret    
80100e1e:	66 90                	xchg   %ax,%ax

80100e20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e20:	f3 0f 1e fb          	endbr32 
80100e24:	55                   	push   %ebp
80100e25:	89 e5                	mov    %esp,%ebp
80100e27:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e28:	bb 14 10 11 80       	mov    $0x80111014,%ebx
{
80100e2d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e30:	68 e0 0f 11 80       	push   $0x80110fe0
80100e35:	e8 a6 3c 00 00       	call   80104ae0 <acquire>
80100e3a:	83 c4 10             	add    $0x10,%esp
80100e3d:	eb 0c                	jmp    80100e4b <filealloc+0x2b>
80100e3f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e40:	83 c3 18             	add    $0x18,%ebx
80100e43:	81 fb 74 19 11 80    	cmp    $0x80111974,%ebx
80100e49:	74 25                	je     80100e70 <filealloc+0x50>
    if(f->ref == 0){
80100e4b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e4e:	85 c0                	test   %eax,%eax
80100e50:	75 ee                	jne    80100e40 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e52:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e55:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e5c:	68 e0 0f 11 80       	push   $0x80110fe0
80100e61:	e8 3a 3d 00 00       	call   80104ba0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e66:	89 d8                	mov    %ebx,%eax
      return f;
80100e68:	83 c4 10             	add    $0x10,%esp
}
80100e6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e6e:	c9                   	leave  
80100e6f:	c3                   	ret    
  release(&ftable.lock);
80100e70:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e73:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e75:	68 e0 0f 11 80       	push   $0x80110fe0
80100e7a:	e8 21 3d 00 00       	call   80104ba0 <release>
}
80100e7f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e81:	83 c4 10             	add    $0x10,%esp
}
80100e84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e87:	c9                   	leave  
80100e88:	c3                   	ret    
80100e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e90 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e90:	f3 0f 1e fb          	endbr32 
80100e94:	55                   	push   %ebp
80100e95:	89 e5                	mov    %esp,%ebp
80100e97:	53                   	push   %ebx
80100e98:	83 ec 10             	sub    $0x10,%esp
80100e9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e9e:	68 e0 0f 11 80       	push   $0x80110fe0
80100ea3:	e8 38 3c 00 00       	call   80104ae0 <acquire>
  if(f->ref < 1)
80100ea8:	8b 43 04             	mov    0x4(%ebx),%eax
80100eab:	83 c4 10             	add    $0x10,%esp
80100eae:	85 c0                	test   %eax,%eax
80100eb0:	7e 1a                	jle    80100ecc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100eb2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100eb5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100eb8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ebb:	68 e0 0f 11 80       	push   $0x80110fe0
80100ec0:	e8 db 3c 00 00       	call   80104ba0 <release>
  return f;
}
80100ec5:	89 d8                	mov    %ebx,%eax
80100ec7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eca:	c9                   	leave  
80100ecb:	c3                   	ret    
    panic("filedup");
80100ecc:	83 ec 0c             	sub    $0xc,%esp
80100ecf:	68 94 77 10 80       	push   $0x80107794
80100ed4:	e8 b7 f4 ff ff       	call   80100390 <panic>
80100ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ee0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ee0:	f3 0f 1e fb          	endbr32 
80100ee4:	55                   	push   %ebp
80100ee5:	89 e5                	mov    %esp,%ebp
80100ee7:	57                   	push   %edi
80100ee8:	56                   	push   %esi
80100ee9:	53                   	push   %ebx
80100eea:	83 ec 28             	sub    $0x28,%esp
80100eed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ef0:	68 e0 0f 11 80       	push   $0x80110fe0
80100ef5:	e8 e6 3b 00 00       	call   80104ae0 <acquire>
  if(f->ref < 1)
80100efa:	8b 53 04             	mov    0x4(%ebx),%edx
80100efd:	83 c4 10             	add    $0x10,%esp
80100f00:	85 d2                	test   %edx,%edx
80100f02:	0f 8e a1 00 00 00    	jle    80100fa9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f08:	83 ea 01             	sub    $0x1,%edx
80100f0b:	89 53 04             	mov    %edx,0x4(%ebx)
80100f0e:	75 40                	jne    80100f50 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f10:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f14:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f17:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f19:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f1f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f22:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f25:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f28:	68 e0 0f 11 80       	push   $0x80110fe0
  ff = *f;
80100f2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f30:	e8 6b 3c 00 00       	call   80104ba0 <release>

  if(ff.type == FD_PIPE)
80100f35:	83 c4 10             	add    $0x10,%esp
80100f38:	83 ff 01             	cmp    $0x1,%edi
80100f3b:	74 53                	je     80100f90 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f3d:	83 ff 02             	cmp    $0x2,%edi
80100f40:	74 26                	je     80100f68 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f45:	5b                   	pop    %ebx
80100f46:	5e                   	pop    %esi
80100f47:	5f                   	pop    %edi
80100f48:	5d                   	pop    %ebp
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f50:	c7 45 08 e0 0f 11 80 	movl   $0x80110fe0,0x8(%ebp)
}
80100f57:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5a:	5b                   	pop    %ebx
80100f5b:	5e                   	pop    %esi
80100f5c:	5f                   	pop    %edi
80100f5d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f5e:	e9 3d 3c 00 00       	jmp    80104ba0 <release>
80100f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f67:	90                   	nop
    begin_op();
80100f68:	e8 e3 1d 00 00       	call   80102d50 <begin_op>
    iput(ff.ip);
80100f6d:	83 ec 0c             	sub    $0xc,%esp
80100f70:	ff 75 e0             	pushl  -0x20(%ebp)
80100f73:	e8 38 09 00 00       	call   801018b0 <iput>
    end_op();
80100f78:	83 c4 10             	add    $0x10,%esp
}
80100f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7e:	5b                   	pop    %ebx
80100f7f:	5e                   	pop    %esi
80100f80:	5f                   	pop    %edi
80100f81:	5d                   	pop    %ebp
    end_op();
80100f82:	e9 39 1e 00 00       	jmp    80102dc0 <end_op>
80100f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f8e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f90:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f94:	83 ec 08             	sub    $0x8,%esp
80100f97:	53                   	push   %ebx
80100f98:	56                   	push   %esi
80100f99:	e8 82 25 00 00       	call   80103520 <pipeclose>
80100f9e:	83 c4 10             	add    $0x10,%esp
}
80100fa1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa4:	5b                   	pop    %ebx
80100fa5:	5e                   	pop    %esi
80100fa6:	5f                   	pop    %edi
80100fa7:	5d                   	pop    %ebp
80100fa8:	c3                   	ret    
    panic("fileclose");
80100fa9:	83 ec 0c             	sub    $0xc,%esp
80100fac:	68 9c 77 10 80       	push   $0x8010779c
80100fb1:	e8 da f3 ff ff       	call   80100390 <panic>
80100fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbd:	8d 76 00             	lea    0x0(%esi),%esi

80100fc0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fc0:	f3 0f 1e fb          	endbr32 
80100fc4:	55                   	push   %ebp
80100fc5:	89 e5                	mov    %esp,%ebp
80100fc7:	53                   	push   %ebx
80100fc8:	83 ec 04             	sub    $0x4,%esp
80100fcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fce:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fd1:	75 2d                	jne    80101000 <filestat+0x40>
    ilock(f->ip);
80100fd3:	83 ec 0c             	sub    $0xc,%esp
80100fd6:	ff 73 10             	pushl  0x10(%ebx)
80100fd9:	e8 a2 07 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100fde:	58                   	pop    %eax
80100fdf:	5a                   	pop    %edx
80100fe0:	ff 75 0c             	pushl  0xc(%ebp)
80100fe3:	ff 73 10             	pushl  0x10(%ebx)
80100fe6:	e8 65 0a 00 00       	call   80101a50 <stati>
    iunlock(f->ip);
80100feb:	59                   	pop    %ecx
80100fec:	ff 73 10             	pushl  0x10(%ebx)
80100fef:	e8 6c 08 00 00       	call   80101860 <iunlock>
    return 0;
  }
  return -1;
}
80100ff4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100ff7:	83 c4 10             	add    $0x10,%esp
80100ffa:	31 c0                	xor    %eax,%eax
}
80100ffc:	c9                   	leave  
80100ffd:	c3                   	ret    
80100ffe:	66 90                	xchg   %ax,%ax
80101000:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101010 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101010:	f3 0f 1e fb          	endbr32 
80101014:	55                   	push   %ebp
80101015:	89 e5                	mov    %esp,%ebp
80101017:	57                   	push   %edi
80101018:	56                   	push   %esi
80101019:	53                   	push   %ebx
8010101a:	83 ec 0c             	sub    $0xc,%esp
8010101d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101020:	8b 75 0c             	mov    0xc(%ebp),%esi
80101023:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101026:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010102a:	74 64                	je     80101090 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010102c:	8b 03                	mov    (%ebx),%eax
8010102e:	83 f8 01             	cmp    $0x1,%eax
80101031:	74 45                	je     80101078 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101033:	83 f8 02             	cmp    $0x2,%eax
80101036:	75 5f                	jne    80101097 <fileread+0x87>
    ilock(f->ip);
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	ff 73 10             	pushl  0x10(%ebx)
8010103e:	e8 3d 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101043:	57                   	push   %edi
80101044:	ff 73 14             	pushl  0x14(%ebx)
80101047:	56                   	push   %esi
80101048:	ff 73 10             	pushl  0x10(%ebx)
8010104b:	e8 30 0a 00 00       	call   80101a80 <readi>
80101050:	83 c4 20             	add    $0x20,%esp
80101053:	89 c6                	mov    %eax,%esi
80101055:	85 c0                	test   %eax,%eax
80101057:	7e 03                	jle    8010105c <fileread+0x4c>
      f->off += r;
80101059:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010105c:	83 ec 0c             	sub    $0xc,%esp
8010105f:	ff 73 10             	pushl  0x10(%ebx)
80101062:	e8 f9 07 00 00       	call   80101860 <iunlock>
    return r;
80101067:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010106a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010106d:	89 f0                	mov    %esi,%eax
8010106f:	5b                   	pop    %ebx
80101070:	5e                   	pop    %esi
80101071:	5f                   	pop    %edi
80101072:	5d                   	pop    %ebp
80101073:	c3                   	ret    
80101074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101078:	8b 43 0c             	mov    0xc(%ebx),%eax
8010107b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010107e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101081:	5b                   	pop    %ebx
80101082:	5e                   	pop    %esi
80101083:	5f                   	pop    %edi
80101084:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101085:	e9 36 26 00 00       	jmp    801036c0 <piperead>
8010108a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101090:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101095:	eb d3                	jmp    8010106a <fileread+0x5a>
  panic("fileread");
80101097:	83 ec 0c             	sub    $0xc,%esp
8010109a:	68 a6 77 10 80       	push   $0x801077a6
8010109f:	e8 ec f2 ff ff       	call   80100390 <panic>
801010a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010af:	90                   	nop

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	f3 0f 1e fb          	endbr32 
801010b4:	55                   	push   %ebp
801010b5:	89 e5                	mov    %esp,%ebp
801010b7:	57                   	push   %edi
801010b8:	56                   	push   %esi
801010b9:	53                   	push   %ebx
801010ba:	83 ec 1c             	sub    $0x1c,%esp
801010bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801010c0:	8b 75 08             	mov    0x8(%ebp),%esi
801010c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010c9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010d0:	0f 84 c1 00 00 00    	je     80101197 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010d6:	8b 06                	mov    (%esi),%eax
801010d8:	83 f8 01             	cmp    $0x1,%eax
801010db:	0f 84 c3 00 00 00    	je     801011a4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010e1:	83 f8 02             	cmp    $0x2,%eax
801010e4:	0f 85 cc 00 00 00    	jne    801011b6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010ed:	31 ff                	xor    %edi,%edi
    while(i < n){
801010ef:	85 c0                	test   %eax,%eax
801010f1:	7f 34                	jg     80101127 <filewrite+0x77>
801010f3:	e9 98 00 00 00       	jmp    80101190 <filewrite+0xe0>
801010f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ff:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101100:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101103:	83 ec 0c             	sub    $0xc,%esp
80101106:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101109:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010110c:	e8 4f 07 00 00       	call   80101860 <iunlock>
      end_op();
80101111:	e8 aa 1c 00 00       	call   80102dc0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101116:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101119:	83 c4 10             	add    $0x10,%esp
8010111c:	39 c3                	cmp    %eax,%ebx
8010111e:	75 60                	jne    80101180 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101120:	01 df                	add    %ebx,%edi
    while(i < n){
80101122:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101125:	7e 69                	jle    80101190 <filewrite+0xe0>
      int n1 = n - i;
80101127:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010112a:	b8 00 06 00 00       	mov    $0x600,%eax
8010112f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101131:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101137:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010113a:	e8 11 1c 00 00       	call   80102d50 <begin_op>
      ilock(f->ip);
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	ff 76 10             	pushl  0x10(%esi)
80101145:	e8 36 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010114a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010114d:	53                   	push   %ebx
8010114e:	ff 76 14             	pushl  0x14(%esi)
80101151:	01 f8                	add    %edi,%eax
80101153:	50                   	push   %eax
80101154:	ff 76 10             	pushl  0x10(%esi)
80101157:	e8 24 0a 00 00       	call   80101b80 <writei>
8010115c:	83 c4 20             	add    $0x20,%esp
8010115f:	85 c0                	test   %eax,%eax
80101161:	7f 9d                	jg     80101100 <filewrite+0x50>
      iunlock(f->ip);
80101163:	83 ec 0c             	sub    $0xc,%esp
80101166:	ff 76 10             	pushl  0x10(%esi)
80101169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010116c:	e8 ef 06 00 00       	call   80101860 <iunlock>
      end_op();
80101171:	e8 4a 1c 00 00       	call   80102dc0 <end_op>
      if(r < 0)
80101176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101179:	83 c4 10             	add    $0x10,%esp
8010117c:	85 c0                	test   %eax,%eax
8010117e:	75 17                	jne    80101197 <filewrite+0xe7>
        panic("short filewrite");
80101180:	83 ec 0c             	sub    $0xc,%esp
80101183:	68 af 77 10 80       	push   $0x801077af
80101188:	e8 03 f2 ff ff       	call   80100390 <panic>
8010118d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101190:	89 f8                	mov    %edi,%eax
80101192:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101195:	74 05                	je     8010119c <filewrite+0xec>
80101197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010119c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119f:	5b                   	pop    %ebx
801011a0:	5e                   	pop    %esi
801011a1:	5f                   	pop    %edi
801011a2:	5d                   	pop    %ebp
801011a3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011a4:	8b 46 0c             	mov    0xc(%esi),%eax
801011a7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ad:	5b                   	pop    %ebx
801011ae:	5e                   	pop    %esi
801011af:	5f                   	pop    %edi
801011b0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011b1:	e9 0a 24 00 00       	jmp    801035c0 <pipewrite>
  panic("filewrite");
801011b6:	83 ec 0c             	sub    $0xc,%esp
801011b9:	68 b5 77 10 80       	push   $0x801077b5
801011be:	e8 cd f1 ff ff       	call   80100390 <panic>
801011c3:	66 90                	xchg   %ax,%ax
801011c5:	66 90                	xchg   %ax,%ax
801011c7:	66 90                	xchg   %ax,%ax
801011c9:	66 90                	xchg   %ax,%ax
801011cb:	66 90                	xchg   %ax,%ax
801011cd:	66 90                	xchg   %ax,%ax
801011cf:	90                   	nop

801011d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011d0:	55                   	push   %ebp
801011d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011d3:	89 d0                	mov    %edx,%eax
801011d5:	c1 e8 0c             	shr    $0xc,%eax
801011d8:	03 05 f8 19 11 80    	add    0x801119f8,%eax
{
801011de:	89 e5                	mov    %esp,%ebp
801011e0:	56                   	push   %esi
801011e1:	53                   	push   %ebx
801011e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	50                   	push   %eax
801011e8:	51                   	push   %ecx
801011e9:	e8 e2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011f0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011f3:	ba 01 00 00 00       	mov    $0x1,%edx
801011f8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011fb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101201:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101204:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101206:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010120b:	85 d1                	test   %edx,%ecx
8010120d:	74 25                	je     80101234 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010120f:	f7 d2                	not    %edx
  log_write(bp);
80101211:	83 ec 0c             	sub    $0xc,%esp
80101214:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101216:	21 ca                	and    %ecx,%edx
80101218:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010121c:	50                   	push   %eax
8010121d:	e8 0e 1d 00 00       	call   80102f30 <log_write>
  brelse(bp);
80101222:	89 34 24             	mov    %esi,(%esp)
80101225:	e8 c6 ef ff ff       	call   801001f0 <brelse>
}
8010122a:	83 c4 10             	add    $0x10,%esp
8010122d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101230:	5b                   	pop    %ebx
80101231:	5e                   	pop    %esi
80101232:	5d                   	pop    %ebp
80101233:	c3                   	ret    
    panic("freeing free block");
80101234:	83 ec 0c             	sub    $0xc,%esp
80101237:	68 bf 77 10 80       	push   $0x801077bf
8010123c:	e8 4f f1 ff ff       	call   80100390 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010124f:	90                   	nop

80101250 <balloc>:
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d e0 19 11 80    	mov    0x801119e0,%ecx
{
8010125f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 87 00 00 00    	je     801012f1 <balloc+0xa1>
8010126a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101271:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101274:	83 ec 08             	sub    $0x8,%esp
80101277:	89 f0                	mov    %esi,%eax
80101279:	c1 f8 0c             	sar    $0xc,%eax
8010127c:	03 05 f8 19 11 80    	add    0x801119f8,%eax
80101282:	50                   	push   %eax
80101283:	ff 75 d8             	pushl  -0x28(%ebp)
80101286:	e8 45 ee ff ff       	call   801000d0 <bread>
8010128b:	83 c4 10             	add    $0x10,%esp
8010128e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101291:	a1 e0 19 11 80       	mov    0x801119e0,%eax
80101296:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101299:	31 c0                	xor    %eax,%eax
8010129b:	eb 2f                	jmp    801012cc <balloc+0x7c>
8010129d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 41                	je     80101300 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 05                	je     801012d1 <balloc+0x81>
801012cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012cf:	77 cf                	ja     801012a0 <balloc+0x50>
    brelse(bp);
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012d7:	e8 14 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012e9:	39 05 e0 19 11 80    	cmp    %eax,0x801119e0
801012ef:	77 80                	ja     80101271 <balloc+0x21>
  panic("balloc: out of blocks");
801012f1:	83 ec 0c             	sub    $0xc,%esp
801012f4:	68 d2 77 10 80       	push   $0x801077d2
801012f9:	e8 92 f0 ff ff       	call   80100390 <panic>
801012fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101300:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101303:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101306:	09 da                	or     %ebx,%edx
80101308:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 1e 1c 00 00       	call   80102f30 <log_write>
        brelse(bp);
80101312:	89 3c 24             	mov    %edi,(%esp)
80101315:	e8 d6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010131a:	58                   	pop    %eax
8010131b:	5a                   	pop    %edx
8010131c:	56                   	push   %esi
8010131d:	ff 75 d8             	pushl  -0x28(%ebp)
80101320:	e8 ab ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101325:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101328:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010132a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010132d:	68 00 02 00 00       	push   $0x200
80101332:	6a 00                	push   $0x0
80101334:	50                   	push   %eax
80101335:	e8 b6 38 00 00       	call   80104bf0 <memset>
  log_write(bp);
8010133a:	89 1c 24             	mov    %ebx,(%esp)
8010133d:	e8 ee 1b 00 00       	call   80102f30 <log_write>
  brelse(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	89 c7                	mov    %eax,%edi
80101366:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101367:	31 f6                	xor    %esi,%esi
{
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 00 1a 11 80       	push   $0x80111a00
8010137a:	e8 61 37 00 00       	call   80104ae0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 3b                	cmp    %edi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139a:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801013a0:	73 26                	jae    801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 f6                	test   %esi,%esi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	89 d8                	mov    %ebx,%eax
801013af:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b5:	85 c9                	test   %ecx,%ecx
801013b7:	75 6e                	jne    80101427 <iget+0xc7>
801013b9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013bb:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
801013c1:	72 df                	jb     801013a2 <iget+0x42>
801013c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013c7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c8:	85 f6                	test   %esi,%esi
801013ca:	74 73                	je     8010143f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013e2:	68 00 1a 11 80       	push   $0x80111a00
801013e7:	e8 b4 37 00 00       	call   80104ba0 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f0                	mov    %esi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret    
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      release(&icache.lock);
80101405:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101408:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010140b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010140d:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
80101412:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101415:	e8 86 37 00 00       	call   80104ba0 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f0                	mov    %esi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
8010142d:	73 10                	jae    8010143f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010142f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101432:	85 c9                	test   %ecx,%ecx
80101434:	0f 8f 56 ff ff ff    	jg     80101390 <iget+0x30>
8010143a:	e9 6e ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
8010143f:	83 ec 0c             	sub    $0xc,%esp
80101442:	68 e8 77 10 80       	push   $0x801077e8
80101447:	e8 44 ef ff ff       	call   80100390 <panic>
8010144c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101450 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	57                   	push   %edi
80101454:	56                   	push   %esi
80101455:	89 c6                	mov    %eax,%esi
80101457:	53                   	push   %ebx
80101458:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010145b:	83 fa 0b             	cmp    $0xb,%edx
8010145e:	0f 86 84 00 00 00    	jbe    801014e8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101464:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101467:	83 fb 7f             	cmp    $0x7f,%ebx
8010146a:	0f 87 98 00 00 00    	ja     80101508 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101470:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101476:	8b 16                	mov    (%esi),%edx
80101478:	85 c0                	test   %eax,%eax
8010147a:	74 54                	je     801014d0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010147c:	83 ec 08             	sub    $0x8,%esp
8010147f:	50                   	push   %eax
80101480:	52                   	push   %edx
80101481:	e8 4a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101486:	83 c4 10             	add    $0x10,%esp
80101489:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010148d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010148f:	8b 1a                	mov    (%edx),%ebx
80101491:	85 db                	test   %ebx,%ebx
80101493:	74 1b                	je     801014b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101495:	83 ec 0c             	sub    $0xc,%esp
80101498:	57                   	push   %edi
80101499:	e8 52 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010149e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801014a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a4:	89 d8                	mov    %ebx,%eax
801014a6:	5b                   	pop    %ebx
801014a7:	5e                   	pop    %esi
801014a8:	5f                   	pop    %edi
801014a9:	5d                   	pop    %ebp
801014aa:	c3                   	ret    
801014ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014af:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014b0:	8b 06                	mov    (%esi),%eax
801014b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014b5:	e8 96 fd ff ff       	call   80101250 <balloc>
801014ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014c0:	89 c3                	mov    %eax,%ebx
801014c2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014c4:	57                   	push   %edi
801014c5:	e8 66 1a 00 00       	call   80102f30 <log_write>
801014ca:	83 c4 10             	add    $0x10,%esp
801014cd:	eb c6                	jmp    80101495 <bmap+0x45>
801014cf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014d0:	89 d0                	mov    %edx,%eax
801014d2:	e8 79 fd ff ff       	call   80101250 <balloc>
801014d7:	8b 16                	mov    (%esi),%edx
801014d9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014df:	eb 9b                	jmp    8010147c <bmap+0x2c>
801014e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014e8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014eb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ee:	85 db                	test   %ebx,%ebx
801014f0:	75 af                	jne    801014a1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014f2:	8b 00                	mov    (%eax),%eax
801014f4:	e8 57 fd ff ff       	call   80101250 <balloc>
801014f9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014fc:	89 c3                	mov    %eax,%ebx
}
801014fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101501:	89 d8                	mov    %ebx,%eax
80101503:	5b                   	pop    %ebx
80101504:	5e                   	pop    %esi
80101505:	5f                   	pop    %edi
80101506:	5d                   	pop    %ebp
80101507:	c3                   	ret    
  panic("bmap: out of range");
80101508:	83 ec 0c             	sub    $0xc,%esp
8010150b:	68 f8 77 10 80       	push   $0x801077f8
80101510:	e8 7b ee ff ff       	call   80100390 <panic>
80101515:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <readsb>:
{
80101520:	f3 0f 1e fb          	endbr32 
80101524:	55                   	push   %ebp
80101525:	89 e5                	mov    %esp,%ebp
80101527:	56                   	push   %esi
80101528:	53                   	push   %ebx
80101529:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010152c:	83 ec 08             	sub    $0x8,%esp
8010152f:	6a 01                	push   $0x1
80101531:	ff 75 08             	pushl  0x8(%ebp)
80101534:	e8 97 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101539:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010153c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010153e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101541:	6a 1c                	push   $0x1c
80101543:	50                   	push   %eax
80101544:	56                   	push   %esi
80101545:	e8 46 37 00 00       	call   80104c90 <memmove>
  brelse(bp);
8010154a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010154d:	83 c4 10             	add    $0x10,%esp
}
80101550:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101553:	5b                   	pop    %ebx
80101554:	5e                   	pop    %esi
80101555:	5d                   	pop    %ebp
  brelse(bp);
80101556:	e9 95 ec ff ff       	jmp    801001f0 <brelse>
8010155b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010155f:	90                   	nop

80101560 <iinit>:
{
80101560:	f3 0f 1e fb          	endbr32 
80101564:	55                   	push   %ebp
80101565:	89 e5                	mov    %esp,%ebp
80101567:	53                   	push   %ebx
80101568:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
8010156d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101570:	68 0b 78 10 80       	push   $0x8010780b
80101575:	68 00 1a 11 80       	push   $0x80111a00
8010157a:	e8 e1 33 00 00       	call   80104960 <initlock>
  for(i = 0; i < NINODE; i++) {
8010157f:	83 c4 10             	add    $0x10,%esp
80101582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101588:	83 ec 08             	sub    $0x8,%esp
8010158b:	68 12 78 10 80       	push   $0x80107812
80101590:	53                   	push   %ebx
80101591:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101597:	e8 84 32 00 00       	call   80104820 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010159c:	83 c4 10             	add    $0x10,%esp
8010159f:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801015a5:	75 e1                	jne    80101588 <iinit+0x28>
  readsb(dev, &sb);
801015a7:	83 ec 08             	sub    $0x8,%esp
801015aa:	68 e0 19 11 80       	push   $0x801119e0
801015af:	ff 75 08             	pushl  0x8(%ebp)
801015b2:	e8 69 ff ff ff       	call   80101520 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015b7:	ff 35 f8 19 11 80    	pushl  0x801119f8
801015bd:	ff 35 f4 19 11 80    	pushl  0x801119f4
801015c3:	ff 35 f0 19 11 80    	pushl  0x801119f0
801015c9:	ff 35 ec 19 11 80    	pushl  0x801119ec
801015cf:	ff 35 e8 19 11 80    	pushl  0x801119e8
801015d5:	ff 35 e4 19 11 80    	pushl  0x801119e4
801015db:	ff 35 e0 19 11 80    	pushl  0x801119e0
801015e1:	68 78 78 10 80       	push   $0x80107878
801015e6:	e8 c5 f0 ff ff       	call   801006b0 <cprintf>
}
801015eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ee:	83 c4 30             	add    $0x30,%esp
801015f1:	c9                   	leave  
801015f2:	c3                   	ret    
801015f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101600 <ialloc>:
{
80101600:	f3 0f 1e fb          	endbr32 
80101604:	55                   	push   %ebp
80101605:	89 e5                	mov    %esp,%ebp
80101607:	57                   	push   %edi
80101608:	56                   	push   %esi
80101609:	53                   	push   %ebx
8010160a:	83 ec 1c             	sub    $0x1c,%esp
8010160d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101610:	83 3d e8 19 11 80 01 	cmpl   $0x1,0x801119e8
{
80101617:	8b 75 08             	mov    0x8(%ebp),%esi
8010161a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010161d:	0f 86 8d 00 00 00    	jbe    801016b0 <ialloc+0xb0>
80101623:	bf 01 00 00 00       	mov    $0x1,%edi
80101628:	eb 1d                	jmp    80101647 <ialloc+0x47>
8010162a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101630:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101633:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101636:	53                   	push   %ebx
80101637:	e8 b4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 c4 10             	add    $0x10,%esp
8010163f:	3b 3d e8 19 11 80    	cmp    0x801119e8,%edi
80101645:	73 69                	jae    801016b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101647:	89 f8                	mov    %edi,%eax
80101649:	83 ec 08             	sub    $0x8,%esp
8010164c:	c1 e8 03             	shr    $0x3,%eax
8010164f:	03 05 f4 19 11 80    	add    0x801119f4,%eax
80101655:	50                   	push   %eax
80101656:	56                   	push   %esi
80101657:	e8 74 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010165c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010165f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101661:	89 f8                	mov    %edi,%eax
80101663:	83 e0 07             	and    $0x7,%eax
80101666:	c1 e0 06             	shl    $0x6,%eax
80101669:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010166d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101671:	75 bd                	jne    80101630 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101673:	83 ec 04             	sub    $0x4,%esp
80101676:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101679:	6a 40                	push   $0x40
8010167b:	6a 00                	push   $0x0
8010167d:	51                   	push   %ecx
8010167e:	e8 6d 35 00 00       	call   80104bf0 <memset>
      dip->type = type;
80101683:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101687:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010168a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010168d:	89 1c 24             	mov    %ebx,(%esp)
80101690:	e8 9b 18 00 00       	call   80102f30 <log_write>
      brelse(bp);
80101695:	89 1c 24             	mov    %ebx,(%esp)
80101698:	e8 53 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010169d:	83 c4 10             	add    $0x10,%esp
}
801016a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016a3:	89 fa                	mov    %edi,%edx
}
801016a5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016a6:	89 f0                	mov    %esi,%eax
}
801016a8:	5e                   	pop    %esi
801016a9:	5f                   	pop    %edi
801016aa:	5d                   	pop    %ebp
      return iget(dev, inum);
801016ab:	e9 b0 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
801016b0:	83 ec 0c             	sub    $0xc,%esp
801016b3:	68 18 78 10 80       	push   $0x80107818
801016b8:	e8 d3 ec ff ff       	call   80100390 <panic>
801016bd:	8d 76 00             	lea    0x0(%esi),%esi

801016c0 <iupdate>:
{
801016c0:	f3 0f 1e fb          	endbr32 
801016c4:	55                   	push   %ebp
801016c5:	89 e5                	mov    %esp,%ebp
801016c7:	56                   	push   %esi
801016c8:	53                   	push   %ebx
801016c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016cc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d2:	83 ec 08             	sub    $0x8,%esp
801016d5:	c1 e8 03             	shr    $0x3,%eax
801016d8:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801016de:	50                   	push   %eax
801016df:	ff 73 a4             	pushl  -0x5c(%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016e7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016eb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ee:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016f3:	83 e0 07             	and    $0x7,%eax
801016f6:	c1 e0 06             	shl    $0x6,%eax
801016f9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016fd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101700:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101704:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101707:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010170b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010170f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101713:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101717:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010171b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010171e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	53                   	push   %ebx
80101724:	50                   	push   %eax
80101725:	e8 66 35 00 00       	call   80104c90 <memmove>
  log_write(bp);
8010172a:	89 34 24             	mov    %esi,(%esp)
8010172d:	e8 fe 17 00 00       	call   80102f30 <log_write>
  brelse(bp);
80101732:	89 75 08             	mov    %esi,0x8(%ebp)
80101735:	83 c4 10             	add    $0x10,%esp
}
80101738:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010173b:	5b                   	pop    %ebx
8010173c:	5e                   	pop    %esi
8010173d:	5d                   	pop    %ebp
  brelse(bp);
8010173e:	e9 ad ea ff ff       	jmp    801001f0 <brelse>
80101743:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101750 <idup>:
{
80101750:	f3 0f 1e fb          	endbr32 
80101754:	55                   	push   %ebp
80101755:	89 e5                	mov    %esp,%ebp
80101757:	53                   	push   %ebx
80101758:	83 ec 10             	sub    $0x10,%esp
8010175b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175e:	68 00 1a 11 80       	push   $0x80111a00
80101763:	e8 78 33 00 00       	call   80104ae0 <acquire>
  ip->ref++;
80101768:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010176c:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101773:	e8 28 34 00 00       	call   80104ba0 <release>
}
80101778:	89 d8                	mov    %ebx,%eax
8010177a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010177d:	c9                   	leave  
8010177e:	c3                   	ret    
8010177f:	90                   	nop

80101780 <ilock>:
{
80101780:	f3 0f 1e fb          	endbr32 
80101784:	55                   	push   %ebp
80101785:	89 e5                	mov    %esp,%ebp
80101787:	56                   	push   %esi
80101788:	53                   	push   %ebx
80101789:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010178c:	85 db                	test   %ebx,%ebx
8010178e:	0f 84 b3 00 00 00    	je     80101847 <ilock+0xc7>
80101794:	8b 53 08             	mov    0x8(%ebx),%edx
80101797:	85 d2                	test   %edx,%edx
80101799:	0f 8e a8 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179f:	83 ec 0c             	sub    $0xc,%esp
801017a2:	8d 43 0c             	lea    0xc(%ebx),%eax
801017a5:	50                   	push   %eax
801017a6:	e8 b5 30 00 00       	call   80104860 <acquiresleep>
  if(ip->valid == 0){
801017ab:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ae:	83 c4 10             	add    $0x10,%esp
801017b1:	85 c0                	test   %eax,%eax
801017b3:	74 0b                	je     801017c0 <ilock+0x40>
}
801017b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b8:	5b                   	pop    %ebx
801017b9:	5e                   	pop    %esi
801017ba:	5d                   	pop    %ebp
801017bb:	c3                   	ret    
801017bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 f4 19 11 80    	add    0x801119f4,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	pushl  (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017da:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017dc:	8b 43 04             	mov    0x4(%ebx),%eax
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 73 34 00 00       	call   80104c90 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 cb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 7b ff ff ff    	jne    801017b5 <ilock+0x35>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 30 78 10 80       	push   $0x80107830
80101842:	e8 49 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 2a 78 10 80       	push   $0x8010782a
8010184f:	e8 3c eb ff ff       	call   80100390 <panic>
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iunlock>:
{
80101860:	f3 0f 1e fb          	endbr32 
80101864:	55                   	push   %ebp
80101865:	89 e5                	mov    %esp,%ebp
80101867:	56                   	push   %esi
80101868:	53                   	push   %ebx
80101869:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010186c:	85 db                	test   %ebx,%ebx
8010186e:	74 28                	je     80101898 <iunlock+0x38>
80101870:	83 ec 0c             	sub    $0xc,%esp
80101873:	8d 73 0c             	lea    0xc(%ebx),%esi
80101876:	56                   	push   %esi
80101877:	e8 84 30 00 00       	call   80104900 <holdingsleep>
8010187c:	83 c4 10             	add    $0x10,%esp
8010187f:	85 c0                	test   %eax,%eax
80101881:	74 15                	je     80101898 <iunlock+0x38>
80101883:	8b 43 08             	mov    0x8(%ebx),%eax
80101886:	85 c0                	test   %eax,%eax
80101888:	7e 0e                	jle    80101898 <iunlock+0x38>
  releasesleep(&ip->lock);
8010188a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010188d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101890:	5b                   	pop    %ebx
80101891:	5e                   	pop    %esi
80101892:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101893:	e9 28 30 00 00       	jmp    801048c0 <releasesleep>
    panic("iunlock");
80101898:	83 ec 0c             	sub    $0xc,%esp
8010189b:	68 3f 78 10 80       	push   $0x8010783f
801018a0:	e8 eb ea ff ff       	call   80100390 <panic>
801018a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <iput>:
{
801018b0:	f3 0f 1e fb          	endbr32 
801018b4:	55                   	push   %ebp
801018b5:	89 e5                	mov    %esp,%ebp
801018b7:	57                   	push   %edi
801018b8:	56                   	push   %esi
801018b9:	53                   	push   %ebx
801018ba:	83 ec 28             	sub    $0x28,%esp
801018bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018c0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018c3:	57                   	push   %edi
801018c4:	e8 97 2f 00 00       	call   80104860 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018cc:	83 c4 10             	add    $0x10,%esp
801018cf:	85 d2                	test   %edx,%edx
801018d1:	74 07                	je     801018da <iput+0x2a>
801018d3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018d8:	74 36                	je     80101910 <iput+0x60>
  releasesleep(&ip->lock);
801018da:	83 ec 0c             	sub    $0xc,%esp
801018dd:	57                   	push   %edi
801018de:	e8 dd 2f 00 00       	call   801048c0 <releasesleep>
  acquire(&icache.lock);
801018e3:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801018ea:	e8 f1 31 00 00       	call   80104ae0 <acquire>
  ip->ref--;
801018ef:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
801018fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101900:	5b                   	pop    %ebx
80101901:	5e                   	pop    %esi
80101902:	5f                   	pop    %edi
80101903:	5d                   	pop    %ebp
  release(&icache.lock);
80101904:	e9 97 32 00 00       	jmp    80104ba0 <release>
80101909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101910:	83 ec 0c             	sub    $0xc,%esp
80101913:	68 00 1a 11 80       	push   $0x80111a00
80101918:	e8 c3 31 00 00       	call   80104ae0 <acquire>
    int r = ip->ref;
8010191d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101920:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101927:	e8 74 32 00 00       	call   80104ba0 <release>
    if(r == 1){
8010192c:	83 c4 10             	add    $0x10,%esp
8010192f:	83 fe 01             	cmp    $0x1,%esi
80101932:	75 a6                	jne    801018da <iput+0x2a>
80101934:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010193a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010193d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101940:	89 cf                	mov    %ecx,%edi
80101942:	eb 0b                	jmp    8010194f <iput+0x9f>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101948:	83 c6 04             	add    $0x4,%esi
8010194b:	39 fe                	cmp    %edi,%esi
8010194d:	74 19                	je     80101968 <iput+0xb8>
    if(ip->addrs[i]){
8010194f:	8b 16                	mov    (%esi),%edx
80101951:	85 d2                	test   %edx,%edx
80101953:	74 f3                	je     80101948 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101955:	8b 03                	mov    (%ebx),%eax
80101957:	e8 74 f8 ff ff       	call   801011d0 <bfree>
      ip->addrs[i] = 0;
8010195c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101962:	eb e4                	jmp    80101948 <iput+0x98>
80101964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101968:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010196e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101971:	85 c0                	test   %eax,%eax
80101973:	75 33                	jne    801019a8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101975:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101978:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010197f:	53                   	push   %ebx
80101980:	e8 3b fd ff ff       	call   801016c0 <iupdate>
      ip->type = 0;
80101985:	31 c0                	xor    %eax,%eax
80101987:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010198b:	89 1c 24             	mov    %ebx,(%esp)
8010198e:	e8 2d fd ff ff       	call   801016c0 <iupdate>
      ip->valid = 0;
80101993:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010199a:	83 c4 10             	add    $0x10,%esp
8010199d:	e9 38 ff ff ff       	jmp    801018da <iput+0x2a>
801019a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019a8:	83 ec 08             	sub    $0x8,%esp
801019ab:	50                   	push   %eax
801019ac:	ff 33                	pushl  (%ebx)
801019ae:	e8 1d e7 ff ff       	call   801000d0 <bread>
801019b3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019b6:	83 c4 10             	add    $0x10,%esp
801019b9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019c2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019c5:	89 cf                	mov    %ecx,%edi
801019c7:	eb 0e                	jmp    801019d7 <iput+0x127>
801019c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 f7                	cmp    %esi,%edi
801019d5:	74 19                	je     801019f0 <iput+0x140>
      if(a[j])
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019dd:	8b 03                	mov    (%ebx),%eax
801019df:	e8 ec f7 ff ff       	call   801011d0 <bfree>
801019e4:	eb ea                	jmp    801019d0 <iput+0x120>
801019e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ed:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019f0:	83 ec 0c             	sub    $0xc,%esp
801019f3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019f6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019f9:	e8 f2 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019fe:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a04:	8b 03                	mov    (%ebx),%eax
80101a06:	e8 c5 f7 ff ff       	call   801011d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a0b:	83 c4 10             	add    $0x10,%esp
80101a0e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a15:	00 00 00 
80101a18:	e9 58 ff ff ff       	jmp    80101975 <iput+0xc5>
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi

80101a20 <iunlockput>:
{
80101a20:	f3 0f 1e fb          	endbr32 
80101a24:	55                   	push   %ebp
80101a25:	89 e5                	mov    %esp,%ebp
80101a27:	53                   	push   %ebx
80101a28:	83 ec 10             	sub    $0x10,%esp
80101a2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a2e:	53                   	push   %ebx
80101a2f:	e8 2c fe ff ff       	call   80101860 <iunlock>
  iput(ip);
80101a34:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a37:	83 c4 10             	add    $0x10,%esp
}
80101a3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a3d:	c9                   	leave  
  iput(ip);
80101a3e:	e9 6d fe ff ff       	jmp    801018b0 <iput>
80101a43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a50:	f3 0f 1e fb          	endbr32 
80101a54:	55                   	push   %ebp
80101a55:	89 e5                	mov    %esp,%ebp
80101a57:	8b 55 08             	mov    0x8(%ebp),%edx
80101a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a5d:	8b 0a                	mov    (%edx),%ecx
80101a5f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a62:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a65:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a68:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a6c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a6f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a73:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a77:	8b 52 58             	mov    0x58(%edx),%edx
80101a7a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a7d:	5d                   	pop    %ebp
80101a7e:	c3                   	ret    
80101a7f:	90                   	nop

80101a80 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a80:	f3 0f 1e fb          	endbr32 
80101a84:	55                   	push   %ebp
80101a85:	89 e5                	mov    %esp,%ebp
80101a87:	57                   	push   %edi
80101a88:	56                   	push   %esi
80101a89:	53                   	push   %ebx
80101a8a:	83 ec 1c             	sub    $0x1c,%esp
80101a8d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a90:	8b 45 08             	mov    0x8(%ebp),%eax
80101a93:	8b 75 10             	mov    0x10(%ebp),%esi
80101a96:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a99:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a9c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aa1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101aa4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101aa7:	0f 84 a3 00 00 00    	je     80101b50 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101aad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ab0:	8b 40 58             	mov    0x58(%eax),%eax
80101ab3:	39 c6                	cmp    %eax,%esi
80101ab5:	0f 87 b6 00 00 00    	ja     80101b71 <readi+0xf1>
80101abb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101abe:	31 c9                	xor    %ecx,%ecx
80101ac0:	89 da                	mov    %ebx,%edx
80101ac2:	01 f2                	add    %esi,%edx
80101ac4:	0f 92 c1             	setb   %cl
80101ac7:	89 cf                	mov    %ecx,%edi
80101ac9:	0f 82 a2 00 00 00    	jb     80101b71 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101acf:	89 c1                	mov    %eax,%ecx
80101ad1:	29 f1                	sub    %esi,%ecx
80101ad3:	39 d0                	cmp    %edx,%eax
80101ad5:	0f 43 cb             	cmovae %ebx,%ecx
80101ad8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101adb:	85 c9                	test   %ecx,%ecx
80101add:	74 63                	je     80101b42 <readi+0xc2>
80101adf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ae3:	89 f2                	mov    %esi,%edx
80101ae5:	c1 ea 09             	shr    $0x9,%edx
80101ae8:	89 d8                	mov    %ebx,%eax
80101aea:	e8 61 f9 ff ff       	call   80101450 <bmap>
80101aef:	83 ec 08             	sub    $0x8,%esp
80101af2:	50                   	push   %eax
80101af3:	ff 33                	pushl  (%ebx)
80101af5:	e8 d6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101afa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101afd:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b02:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b05:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	89 f0                	mov    %esi,%eax
80101b09:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b0e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b10:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b13:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b15:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b19:	39 d9                	cmp    %ebx,%ecx
80101b1b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b1e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b1f:	01 df                	add    %ebx,%edi
80101b21:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b23:	50                   	push   %eax
80101b24:	ff 75 e0             	pushl  -0x20(%ebp)
80101b27:	e8 64 31 00 00       	call   80104c90 <memmove>
    brelse(bp);
80101b2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b2f:	89 14 24             	mov    %edx,(%esp)
80101b32:	e8 b9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b3a:	83 c4 10             	add    $0x10,%esp
80101b3d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b40:	77 9e                	ja     80101ae0 <readi+0x60>
  }
  return n;
80101b42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b48:	5b                   	pop    %ebx
80101b49:	5e                   	pop    %esi
80101b4a:	5f                   	pop    %edi
80101b4b:	5d                   	pop    %ebp
80101b4c:	c3                   	ret    
80101b4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 17                	ja     80101b71 <readi+0xf1>
80101b5a:	8b 04 c5 80 19 11 80 	mov    -0x7feee680(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 0c                	je     80101b71 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b6f:	ff e0                	jmp    *%eax
      return -1;
80101b71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b76:	eb cd                	jmp    80101b45 <readi+0xc5>
80101b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b7f:	90                   	nop

80101b80 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b80:	f3 0f 1e fb          	endbr32 
80101b84:	55                   	push   %ebp
80101b85:	89 e5                	mov    %esp,%ebp
80101b87:	57                   	push   %edi
80101b88:	56                   	push   %esi
80101b89:	53                   	push   %ebx
80101b8a:	83 ec 1c             	sub    $0x1c,%esp
80101b8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b90:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b93:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b96:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b9b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ba1:	8b 75 10             	mov    0x10(%ebp),%esi
80101ba4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ba7:	0f 84 b3 00 00 00    	je     80101c60 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bb0:	39 70 58             	cmp    %esi,0x58(%eax)
80101bb3:	0f 82 e3 00 00 00    	jb     80101c9c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bb9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bbc:	89 f8                	mov    %edi,%eax
80101bbe:	01 f0                	add    %esi,%eax
80101bc0:	0f 82 d6 00 00 00    	jb     80101c9c <writei+0x11c>
80101bc6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bcb:	0f 87 cb 00 00 00    	ja     80101c9c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bd1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bd8:	85 ff                	test   %edi,%edi
80101bda:	74 75                	je     80101c51 <writei+0xd1>
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101be3:	89 f2                	mov    %esi,%edx
80101be5:	c1 ea 09             	shr    $0x9,%edx
80101be8:	89 f8                	mov    %edi,%eax
80101bea:	e8 61 f8 ff ff       	call   80101450 <bmap>
80101bef:	83 ec 08             	sub    $0x8,%esp
80101bf2:	50                   	push   %eax
80101bf3:	ff 37                	pushl  (%edi)
80101bf5:	e8 d6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bfa:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c02:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c05:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 f0                	mov    %esi,%eax
80101c09:	83 c4 0c             	add    $0xc,%esp
80101c0c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c11:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c13:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c17:	39 d9                	cmp    %ebx,%ecx
80101c19:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c1c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c1d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c1f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c22:	50                   	push   %eax
80101c23:	e8 68 30 00 00       	call   80104c90 <memmove>
    log_write(bp);
80101c28:	89 3c 24             	mov    %edi,(%esp)
80101c2b:	e8 00 13 00 00       	call   80102f30 <log_write>
    brelse(bp);
80101c30:	89 3c 24             	mov    %edi,(%esp)
80101c33:	e8 b8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c38:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c3b:	83 c4 10             	add    $0x10,%esp
80101c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c41:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c44:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c47:	77 97                	ja     80101be0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c4c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c4f:	77 37                	ja     80101c88 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c57:	5b                   	pop    %ebx
80101c58:	5e                   	pop    %esi
80101c59:	5f                   	pop    %edi
80101c5a:	5d                   	pop    %ebp
80101c5b:	c3                   	ret    
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c60:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c64:	66 83 f8 09          	cmp    $0x9,%ax
80101c68:	77 32                	ja     80101c9c <writei+0x11c>
80101c6a:	8b 04 c5 84 19 11 80 	mov    -0x7feee67c(,%eax,8),%eax
80101c71:	85 c0                	test   %eax,%eax
80101c73:	74 27                	je     80101c9c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c75:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7b:	5b                   	pop    %ebx
80101c7c:	5e                   	pop    %esi
80101c7d:	5f                   	pop    %edi
80101c7e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c7f:	ff e0                	jmp    *%eax
80101c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c88:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c8b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c8e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c91:	50                   	push   %eax
80101c92:	e8 29 fa ff ff       	call   801016c0 <iupdate>
80101c97:	83 c4 10             	add    $0x10,%esp
80101c9a:	eb b5                	jmp    80101c51 <writei+0xd1>
      return -1;
80101c9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ca1:	eb b1                	jmp    80101c54 <writei+0xd4>
80101ca3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cb0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cba:	6a 0e                	push   $0xe
80101cbc:	ff 75 0c             	pushl  0xc(%ebp)
80101cbf:	ff 75 08             	pushl  0x8(%ebp)
80101cc2:	e8 39 30 00 00       	call   80104d00 <strncmp>
}
80101cc7:	c9                   	leave  
80101cc8:	c3                   	ret    
80101cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cd0:	f3 0f 1e fb          	endbr32 
80101cd4:	55                   	push   %ebp
80101cd5:	89 e5                	mov    %esp,%ebp
80101cd7:	57                   	push   %edi
80101cd8:	56                   	push   %esi
80101cd9:	53                   	push   %ebx
80101cda:	83 ec 1c             	sub    $0x1c,%esp
80101cdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101ce0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101ce5:	0f 85 89 00 00 00    	jne    80101d74 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ceb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cee:	31 ff                	xor    %edi,%edi
80101cf0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cf3:	85 d2                	test   %edx,%edx
80101cf5:	74 42                	je     80101d39 <dirlookup+0x69>
80101cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cfe:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d00:	6a 10                	push   $0x10
80101d02:	57                   	push   %edi
80101d03:	56                   	push   %esi
80101d04:	53                   	push   %ebx
80101d05:	e8 76 fd ff ff       	call   80101a80 <readi>
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	83 f8 10             	cmp    $0x10,%eax
80101d10:	75 55                	jne    80101d67 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d12:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d17:	74 18                	je     80101d31 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d19:	83 ec 04             	sub    $0x4,%esp
80101d1c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d1f:	6a 0e                	push   $0xe
80101d21:	50                   	push   %eax
80101d22:	ff 75 0c             	pushl  0xc(%ebp)
80101d25:	e8 d6 2f 00 00       	call   80104d00 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d2a:	83 c4 10             	add    $0x10,%esp
80101d2d:	85 c0                	test   %eax,%eax
80101d2f:	74 17                	je     80101d48 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d31:	83 c7 10             	add    $0x10,%edi
80101d34:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d37:	72 c7                	jb     80101d00 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d3c:	31 c0                	xor    %eax,%eax
}
80101d3e:	5b                   	pop    %ebx
80101d3f:	5e                   	pop    %esi
80101d40:	5f                   	pop    %edi
80101d41:	5d                   	pop    %ebp
80101d42:	c3                   	ret    
80101d43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d47:	90                   	nop
      if(poff)
80101d48:	8b 45 10             	mov    0x10(%ebp),%eax
80101d4b:	85 c0                	test   %eax,%eax
80101d4d:	74 05                	je     80101d54 <dirlookup+0x84>
        *poff = off;
80101d4f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d52:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d54:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d58:	8b 03                	mov    (%ebx),%eax
80101d5a:	e8 01 f6 ff ff       	call   80101360 <iget>
}
80101d5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d62:	5b                   	pop    %ebx
80101d63:	5e                   	pop    %esi
80101d64:	5f                   	pop    %edi
80101d65:	5d                   	pop    %ebp
80101d66:	c3                   	ret    
      panic("dirlookup read");
80101d67:	83 ec 0c             	sub    $0xc,%esp
80101d6a:	68 59 78 10 80       	push   $0x80107859
80101d6f:	e8 1c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d74:	83 ec 0c             	sub    $0xc,%esp
80101d77:	68 47 78 10 80       	push   $0x80107847
80101d7c:	e8 0f e6 ff ff       	call   80100390 <panic>
80101d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8f:	90                   	nop

80101d90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	89 c3                	mov    %eax,%ebx
80101d98:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d9b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d9e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101da1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101da4:	0f 84 86 01 00 00    	je     80101f30 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101daa:	e8 01 1c 00 00       	call   801039b0 <myproc>
  acquire(&icache.lock);
80101daf:	83 ec 0c             	sub    $0xc,%esp
80101db2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101db4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101db7:	68 00 1a 11 80       	push   $0x80111a00
80101dbc:	e8 1f 2d 00 00       	call   80104ae0 <acquire>
  ip->ref++;
80101dc1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dc5:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101dcc:	e8 cf 2d 00 00       	call   80104ba0 <release>
80101dd1:	83 c4 10             	add    $0x10,%esp
80101dd4:	eb 0d                	jmp    80101de3 <namex+0x53>
80101dd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ddd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101de0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101de3:	0f b6 07             	movzbl (%edi),%eax
80101de6:	3c 2f                	cmp    $0x2f,%al
80101de8:	74 f6                	je     80101de0 <namex+0x50>
  if(*path == 0)
80101dea:	84 c0                	test   %al,%al
80101dec:	0f 84 ee 00 00 00    	je     80101ee0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101df2:	0f b6 07             	movzbl (%edi),%eax
80101df5:	84 c0                	test   %al,%al
80101df7:	0f 84 fb 00 00 00    	je     80101ef8 <namex+0x168>
80101dfd:	89 fb                	mov    %edi,%ebx
80101dff:	3c 2f                	cmp    $0x2f,%al
80101e01:	0f 84 f1 00 00 00    	je     80101ef8 <namex+0x168>
80101e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e0e:	66 90                	xchg   %ax,%ax
80101e10:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e14:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x8f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x80>
  len = path - s;
80101e1f:	89 d8                	mov    %ebx,%eax
80101e21:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e 84 00 00 00    	jle    80101eb0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	57                   	push   %edi
    path++;
80101e32:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e34:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e37:	e8 54 2e 00 00       	call   80104c90 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e42:	75 0c                	jne    80101e50 <namex+0xc0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e4b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e4e:	74 f8                	je     80101e48 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 27 f9 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 a1 00 00 00    	jne    80101f08 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e6a:	85 d2                	test   %edx,%edx
80101e6c:	74 09                	je     80101e77 <namex+0xe7>
80101e6e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e71:	0f 84 d9 00 00 00    	je     80101f50 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 4b fe ff ff       	call   80101cd0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c3                	mov    %eax,%ebx
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	74 7a                	je     80101f08 <namex+0x178>
  iunlock(ip);
80101e8e:	83 ec 0c             	sub    $0xc,%esp
80101e91:	56                   	push   %esi
80101e92:	e8 c9 f9 ff ff       	call   80101860 <iunlock>
  iput(ip);
80101e97:	89 34 24             	mov    %esi,(%esp)
80101e9a:	89 de                	mov    %ebx,%esi
80101e9c:	e8 0f fa ff ff       	call   801018b0 <iput>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	e9 3a ff ff ff       	jmp    80101de3 <namex+0x53>
80101ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101eb3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101eb6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101eb9:	83 ec 04             	sub    $0x4,%esp
80101ebc:	50                   	push   %eax
80101ebd:	57                   	push   %edi
    name[len] = 0;
80101ebe:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ec0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ec3:	e8 c8 2d 00 00       	call   80104c90 <memmove>
    name[len] = 0;
80101ec8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ecb:	83 c4 10             	add    $0x10,%esp
80101ece:	c6 00 00             	movb   $0x0,(%eax)
80101ed1:	e9 69 ff ff ff       	jmp    80101e3f <namex+0xaf>
80101ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101edd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ee0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ee3:	85 c0                	test   %eax,%eax
80101ee5:	0f 85 85 00 00 00    	jne    80101f70 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101eeb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eee:	89 f0                	mov    %esi,%eax
80101ef0:	5b                   	pop    %ebx
80101ef1:	5e                   	pop    %esi
80101ef2:	5f                   	pop    %edi
80101ef3:	5d                   	pop    %ebp
80101ef4:	c3                   	ret    
80101ef5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101efb:	89 fb                	mov    %edi,%ebx
80101efd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f00:	31 c0                	xor    %eax,%eax
80101f02:	eb b5                	jmp    80101eb9 <namex+0x129>
80101f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f08:	83 ec 0c             	sub    $0xc,%esp
80101f0b:	56                   	push   %esi
80101f0c:	e8 4f f9 ff ff       	call   80101860 <iunlock>
  iput(ip);
80101f11:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f14:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f16:	e8 95 f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f1b:	83 c4 10             	add    $0x10,%esp
}
80101f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f21:	89 f0                	mov    %esi,%eax
80101f23:	5b                   	pop    %ebx
80101f24:	5e                   	pop    %esi
80101f25:	5f                   	pop    %edi
80101f26:	5d                   	pop    %ebp
80101f27:	c3                   	ret    
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f30:	ba 01 00 00 00       	mov    $0x1,%edx
80101f35:	b8 01 00 00 00       	mov    $0x1,%eax
80101f3a:	89 df                	mov    %ebx,%edi
80101f3c:	e8 1f f4 ff ff       	call   80101360 <iget>
80101f41:	89 c6                	mov    %eax,%esi
80101f43:	e9 9b fe ff ff       	jmp    80101de3 <namex+0x53>
80101f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4f:	90                   	nop
      iunlock(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
80101f54:	e8 07 f9 ff ff       	call   80101860 <iunlock>
      return ip;
80101f59:	83 c4 10             	add    $0x10,%esp
}
80101f5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f5f:	89 f0                	mov    %esi,%eax
80101f61:	5b                   	pop    %ebx
80101f62:	5e                   	pop    %esi
80101f63:	5f                   	pop    %edi
80101f64:	5d                   	pop    %ebp
80101f65:	c3                   	ret    
80101f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f70:	83 ec 0c             	sub    $0xc,%esp
80101f73:	56                   	push   %esi
    return 0;
80101f74:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f76:	e8 35 f9 ff ff       	call   801018b0 <iput>
    return 0;
80101f7b:	83 c4 10             	add    $0x10,%esp
80101f7e:	e9 68 ff ff ff       	jmp    80101eeb <namex+0x15b>
80101f83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f90 <dirlink>:
{
80101f90:	f3 0f 1e fb          	endbr32 
80101f94:	55                   	push   %ebp
80101f95:	89 e5                	mov    %esp,%ebp
80101f97:	57                   	push   %edi
80101f98:	56                   	push   %esi
80101f99:	53                   	push   %ebx
80101f9a:	83 ec 20             	sub    $0x20,%esp
80101f9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fa0:	6a 00                	push   $0x0
80101fa2:	ff 75 0c             	pushl  0xc(%ebp)
80101fa5:	53                   	push   %ebx
80101fa6:	e8 25 fd ff ff       	call   80101cd0 <dirlookup>
80101fab:	83 c4 10             	add    $0x10,%esp
80101fae:	85 c0                	test   %eax,%eax
80101fb0:	75 6b                	jne    8010201d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fb2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fb5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb8:	85 ff                	test   %edi,%edi
80101fba:	74 2d                	je     80101fe9 <dirlink+0x59>
80101fbc:	31 ff                	xor    %edi,%edi
80101fbe:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fc1:	eb 0d                	jmp    80101fd0 <dirlink+0x40>
80101fc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fc7:	90                   	nop
80101fc8:	83 c7 10             	add    $0x10,%edi
80101fcb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fce:	73 19                	jae    80101fe9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fd0:	6a 10                	push   $0x10
80101fd2:	57                   	push   %edi
80101fd3:	56                   	push   %esi
80101fd4:	53                   	push   %ebx
80101fd5:	e8 a6 fa ff ff       	call   80101a80 <readi>
80101fda:	83 c4 10             	add    $0x10,%esp
80101fdd:	83 f8 10             	cmp    $0x10,%eax
80101fe0:	75 4e                	jne    80102030 <dirlink+0xa0>
    if(de.inum == 0)
80101fe2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fe7:	75 df                	jne    80101fc8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fe9:	83 ec 04             	sub    $0x4,%esp
80101fec:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fef:	6a 0e                	push   $0xe
80101ff1:	ff 75 0c             	pushl  0xc(%ebp)
80101ff4:	50                   	push   %eax
80101ff5:	e8 56 2d 00 00       	call   80104d50 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ffa:	6a 10                	push   $0x10
  de.inum = inum;
80101ffc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fff:	57                   	push   %edi
80102000:	56                   	push   %esi
80102001:	53                   	push   %ebx
  de.inum = inum;
80102002:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102006:	e8 75 fb ff ff       	call   80101b80 <writei>
8010200b:	83 c4 20             	add    $0x20,%esp
8010200e:	83 f8 10             	cmp    $0x10,%eax
80102011:	75 2a                	jne    8010203d <dirlink+0xad>
  return 0;
80102013:	31 c0                	xor    %eax,%eax
}
80102015:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102018:	5b                   	pop    %ebx
80102019:	5e                   	pop    %esi
8010201a:	5f                   	pop    %edi
8010201b:	5d                   	pop    %ebp
8010201c:	c3                   	ret    
    iput(ip);
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	50                   	push   %eax
80102021:	e8 8a f8 ff ff       	call   801018b0 <iput>
    return -1;
80102026:	83 c4 10             	add    $0x10,%esp
80102029:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010202e:	eb e5                	jmp    80102015 <dirlink+0x85>
      panic("dirlink read");
80102030:	83 ec 0c             	sub    $0xc,%esp
80102033:	68 68 78 10 80       	push   $0x80107868
80102038:	e8 53 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010203d:	83 ec 0c             	sub    $0xc,%esp
80102040:	68 6e 7e 10 80       	push   $0x80107e6e
80102045:	e8 46 e3 ff ff       	call   80100390 <panic>
8010204a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102050 <namei>:

struct inode*
namei(char *path)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102055:	31 d2                	xor    %edx,%edx
{
80102057:	89 e5                	mov    %esp,%ebp
80102059:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010205c:	8b 45 08             	mov    0x8(%ebp),%eax
8010205f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102062:	e8 29 fd ff ff       	call   80101d90 <namex>
}
80102067:	c9                   	leave  
80102068:	c3                   	ret    
80102069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102070 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
  return namex(path, 1, name);
80102075:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010207a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010207c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010207f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102082:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102083:	e9 08 fd ff ff       	jmp    80101d90 <namex>
80102088:	66 90                	xchg   %ax,%ax
8010208a:	66 90                	xchg   %ax,%ax
8010208c:	66 90                	xchg   %ax,%ax
8010208e:	66 90                	xchg   %ax,%ax

80102090 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102099:	85 c0                	test   %eax,%eax
8010209b:	0f 84 b4 00 00 00    	je     80102155 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020a1:	8b 70 08             	mov    0x8(%eax),%esi
801020a4:	89 c3                	mov    %eax,%ebx
801020a6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020ac:	0f 87 96 00 00 00    	ja     80102148 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020be:	66 90                	xchg   %ax,%ax
801020c0:	89 ca                	mov    %ecx,%edx
801020c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c3:	83 e0 c0             	and    $0xffffffc0,%eax
801020c6:	3c 40                	cmp    $0x40,%al
801020c8:	75 f6                	jne    801020c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ca:	31 ff                	xor    %edi,%edi
801020cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020d1:	89 f8                	mov    %edi,%eax
801020d3:	ee                   	out    %al,(%dx)
801020d4:	b8 01 00 00 00       	mov    $0x1,%eax
801020d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020de:	ee                   	out    %al,(%dx)
801020df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020e4:	89 f0                	mov    %esi,%eax
801020e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020e7:	89 f0                	mov    %esi,%eax
801020e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ee:	c1 f8 08             	sar    $0x8,%eax
801020f1:	ee                   	out    %al,(%dx)
801020f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020f7:	89 f8                	mov    %edi,%eax
801020f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020fa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102103:	c1 e0 04             	shl    $0x4,%eax
80102106:	83 e0 10             	and    $0x10,%eax
80102109:	83 c8 e0             	or     $0xffffffe0,%eax
8010210c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010210d:	f6 03 04             	testb  $0x4,(%ebx)
80102110:	75 16                	jne    80102128 <idestart+0x98>
80102112:	b8 20 00 00 00       	mov    $0x20,%eax
80102117:	89 ca                	mov    %ecx,%edx
80102119:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010211a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010211d:	5b                   	pop    %ebx
8010211e:	5e                   	pop    %esi
8010211f:	5f                   	pop    %edi
80102120:	5d                   	pop    %ebp
80102121:	c3                   	ret    
80102122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102128:	b8 30 00 00 00       	mov    $0x30,%eax
8010212d:	89 ca                	mov    %ecx,%edx
8010212f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102130:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102135:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102138:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010213d:	fc                   	cld    
8010213e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102140:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102143:	5b                   	pop    %ebx
80102144:	5e                   	pop    %esi
80102145:	5f                   	pop    %edi
80102146:	5d                   	pop    %ebp
80102147:	c3                   	ret    
    panic("incorrect blockno");
80102148:	83 ec 0c             	sub    $0xc,%esp
8010214b:	68 d4 78 10 80       	push   $0x801078d4
80102150:	e8 3b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102155:	83 ec 0c             	sub    $0xc,%esp
80102158:	68 cb 78 10 80       	push   $0x801078cb
8010215d:	e8 2e e2 ff ff       	call   80100390 <panic>
80102162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102170 <ideinit>:
{
80102170:	f3 0f 1e fb          	endbr32 
80102174:	55                   	push   %ebp
80102175:	89 e5                	mov    %esp,%ebp
80102177:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010217a:	68 e6 78 10 80       	push   $0x801078e6
8010217f:	68 80 b5 10 80       	push   $0x8010b580
80102184:	e8 d7 27 00 00       	call   80104960 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102189:	58                   	pop    %eax
8010218a:	a1 20 3d 11 80       	mov    0x80113d20,%eax
8010218f:	5a                   	pop    %edx
80102190:	83 e8 01             	sub    $0x1,%eax
80102193:	50                   	push   %eax
80102194:	6a 0e                	push   $0xe
80102196:	e8 b5 02 00 00       	call   80102450 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010219b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010219e:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021a7:	90                   	nop
801021a8:	ec                   	in     (%dx),%al
801021a9:	83 e0 c0             	and    $0xffffffc0,%eax
801021ac:	3c 40                	cmp    $0x40,%al
801021ae:	75 f8                	jne    801021a8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021b0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021b5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ba:	ee                   	out    %al,(%dx)
801021bb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021c5:	eb 0e                	jmp    801021d5 <ideinit+0x65>
801021c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ce:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021d0:	83 e9 01             	sub    $0x1,%ecx
801021d3:	74 0f                	je     801021e4 <ideinit+0x74>
801021d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021d6:	84 c0                	test   %al,%al
801021d8:	74 f6                	je     801021d0 <ideinit+0x60>
      havedisk1 = 1;
801021da:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ee:	ee                   	out    %al,(%dx)
}
801021ef:	c9                   	leave  
801021f0:	c3                   	ret    
801021f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ff:	90                   	nop

80102200 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102200:	f3 0f 1e fb          	endbr32 
80102204:	55                   	push   %ebp
80102205:	89 e5                	mov    %esp,%ebp
80102207:	57                   	push   %edi
80102208:	56                   	push   %esi
80102209:	53                   	push   %ebx
8010220a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010220d:	68 80 b5 10 80       	push   $0x8010b580
80102212:	e8 c9 28 00 00       	call   80104ae0 <acquire>

  if((b = idequeue) == 0){
80102217:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010221d:	83 c4 10             	add    $0x10,%esp
80102220:	85 db                	test   %ebx,%ebx
80102222:	74 5f                	je     80102283 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102224:	8b 43 58             	mov    0x58(%ebx),%eax
80102227:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010222c:	8b 33                	mov    (%ebx),%esi
8010222e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102234:	75 2b                	jne    80102261 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102236:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010223b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop
80102240:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102241:	89 c1                	mov    %eax,%ecx
80102243:	83 e1 c0             	and    $0xffffffc0,%ecx
80102246:	80 f9 40             	cmp    $0x40,%cl
80102249:	75 f5                	jne    80102240 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010224b:	a8 21                	test   $0x21,%al
8010224d:	75 12                	jne    80102261 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010224f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102252:	b9 80 00 00 00       	mov    $0x80,%ecx
80102257:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010225c:	fc                   	cld    
8010225d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010225f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102261:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102264:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102267:	83 ce 02             	or     $0x2,%esi
8010226a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010226c:	53                   	push   %ebx
8010226d:	e8 9e 20 00 00       	call   80104310 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102272:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102277:	83 c4 10             	add    $0x10,%esp
8010227a:	85 c0                	test   %eax,%eax
8010227c:	74 05                	je     80102283 <ideintr+0x83>
    idestart(idequeue);
8010227e:	e8 0d fe ff ff       	call   80102090 <idestart>
    release(&idelock);
80102283:	83 ec 0c             	sub    $0xc,%esp
80102286:	68 80 b5 10 80       	push   $0x8010b580
8010228b:	e8 10 29 00 00       	call   80104ba0 <release>

  release(&idelock);
}
80102290:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102293:	5b                   	pop    %ebx
80102294:	5e                   	pop    %esi
80102295:	5f                   	pop    %edi
80102296:	5d                   	pop    %ebp
80102297:	c3                   	ret    
80102298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010229f:	90                   	nop

801022a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022a0:	f3 0f 1e fb          	endbr32 
801022a4:	55                   	push   %ebp
801022a5:	89 e5                	mov    %esp,%ebp
801022a7:	53                   	push   %ebx
801022a8:	83 ec 10             	sub    $0x10,%esp
801022ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801022b1:	50                   	push   %eax
801022b2:	e8 49 26 00 00       	call   80104900 <holdingsleep>
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	0f 84 cf 00 00 00    	je     80102391 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022c2:	8b 03                	mov    (%ebx),%eax
801022c4:	83 e0 06             	and    $0x6,%eax
801022c7:	83 f8 02             	cmp    $0x2,%eax
801022ca:	0f 84 b4 00 00 00    	je     80102384 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022d0:	8b 53 04             	mov    0x4(%ebx),%edx
801022d3:	85 d2                	test   %edx,%edx
801022d5:	74 0d                	je     801022e4 <iderw+0x44>
801022d7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022dc:	85 c0                	test   %eax,%eax
801022de:	0f 84 93 00 00 00    	je     80102377 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022e4:	83 ec 0c             	sub    $0xc,%esp
801022e7:	68 80 b5 10 80       	push   $0x8010b580
801022ec:	e8 ef 27 00 00       	call   80104ae0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022f1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022f6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022fd:	83 c4 10             	add    $0x10,%esp
80102300:	85 c0                	test   %eax,%eax
80102302:	74 6c                	je     80102370 <iderw+0xd0>
80102304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102308:	89 c2                	mov    %eax,%edx
8010230a:	8b 40 58             	mov    0x58(%eax),%eax
8010230d:	85 c0                	test   %eax,%eax
8010230f:	75 f7                	jne    80102308 <iderw+0x68>
80102311:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102314:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102316:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010231c:	74 42                	je     80102360 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 e0 06             	and    $0x6,%eax
80102323:	83 f8 02             	cmp    $0x2,%eax
80102326:	74 23                	je     8010234b <iderw+0xab>
80102328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010232f:	90                   	nop
    sleep(b, &idelock);
80102330:	83 ec 08             	sub    $0x8,%esp
80102333:	68 80 b5 10 80       	push   $0x8010b580
80102338:	53                   	push   %ebx
80102339:	e8 b2 1d 00 00       	call   801040f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010233e:	8b 03                	mov    (%ebx),%eax
80102340:	83 c4 10             	add    $0x10,%esp
80102343:	83 e0 06             	and    $0x6,%eax
80102346:	83 f8 02             	cmp    $0x2,%eax
80102349:	75 e5                	jne    80102330 <iderw+0x90>
  }


  release(&idelock);
8010234b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102352:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102355:	c9                   	leave  
  release(&idelock);
80102356:	e9 45 28 00 00       	jmp    80104ba0 <release>
8010235b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010235f:	90                   	nop
    idestart(b);
80102360:	89 d8                	mov    %ebx,%eax
80102362:	e8 29 fd ff ff       	call   80102090 <idestart>
80102367:	eb b5                	jmp    8010231e <iderw+0x7e>
80102369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102370:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102375:	eb 9d                	jmp    80102314 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102377:	83 ec 0c             	sub    $0xc,%esp
8010237a:	68 15 79 10 80       	push   $0x80107915
8010237f:	e8 0c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102384:	83 ec 0c             	sub    $0xc,%esp
80102387:	68 00 79 10 80       	push   $0x80107900
8010238c:	e8 ff df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102391:	83 ec 0c             	sub    $0xc,%esp
80102394:	68 ea 78 10 80       	push   $0x801078ea
80102399:	e8 f2 df ff ff       	call   80100390 <panic>
8010239e:	66 90                	xchg   %ax,%ax

801023a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023a0:	f3 0f 1e fb          	endbr32 
801023a4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023a5:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
801023ac:	00 c0 fe 
{
801023af:	89 e5                	mov    %esp,%ebp
801023b1:	56                   	push   %esi
801023b2:	53                   	push   %ebx
  ioapic->reg = reg;
801023b3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023ba:	00 00 00 
  return ioapic->data;
801023bd:	8b 15 54 36 11 80    	mov    0x80113654,%edx
801023c3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023c6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023cc:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023d2:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023d9:	c1 ee 10             	shr    $0x10,%esi
801023dc:	89 f0                	mov    %esi,%eax
801023de:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023e1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023e4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023e7:	39 c2                	cmp    %eax,%edx
801023e9:	74 16                	je     80102401 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023eb:	83 ec 0c             	sub    $0xc,%esp
801023ee:	68 34 79 10 80       	push   $0x80107934
801023f3:	e8 b8 e2 ff ff       	call   801006b0 <cprintf>
801023f8:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	83 c6 21             	add    $0x21,%esi
{
80102404:	ba 10 00 00 00       	mov    $0x10,%edx
80102409:	b8 20 00 00 00       	mov    $0x20,%eax
8010240e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102410:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102412:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102414:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
8010241a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010241d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102423:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102426:	8d 5a 01             	lea    0x1(%edx),%ebx
80102429:	83 c2 02             	add    $0x2,%edx
8010242c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010242e:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102434:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010243b:	39 f0                	cmp    %esi,%eax
8010243d:	75 d1                	jne    80102410 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010243f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102442:	5b                   	pop    %ebx
80102443:	5e                   	pop    %esi
80102444:	5d                   	pop    %ebp
80102445:	c3                   	ret    
80102446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010244d:	8d 76 00             	lea    0x0(%esi),%esi

80102450 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102450:	f3 0f 1e fb          	endbr32 
80102454:	55                   	push   %ebp
  ioapic->reg = reg;
80102455:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
8010245b:	89 e5                	mov    %esp,%ebp
8010245d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102460:	8d 50 20             	lea    0x20(%eax),%edx
80102463:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102467:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102469:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102472:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102475:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102478:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010247a:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102482:	89 50 10             	mov    %edx,0x10(%eax)
}
80102485:	5d                   	pop    %ebp
80102486:	c3                   	ret    
80102487:	66 90                	xchg   %ax,%ax
80102489:	66 90                	xchg   %ax,%ax
8010248b:	66 90                	xchg   %ax,%ax
8010248d:	66 90                	xchg   %ax,%ax
8010248f:	90                   	nop

80102490 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102490:	f3 0f 1e fb          	endbr32 
80102494:	55                   	push   %ebp
80102495:	89 e5                	mov    %esp,%ebp
80102497:	53                   	push   %ebx
80102498:	83 ec 04             	sub    $0x4,%esp
8010249b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010249e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024a4:	75 7a                	jne    80102520 <kfree+0x90>
801024a6:	81 fb 08 68 11 80    	cmp    $0x80116808,%ebx
801024ac:	72 72                	jb     80102520 <kfree+0x90>
801024ae:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024b4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024b9:	77 65                	ja     80102520 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024bb:	83 ec 04             	sub    $0x4,%esp
801024be:	68 00 10 00 00       	push   $0x1000
801024c3:	6a 01                	push   $0x1
801024c5:	53                   	push   %ebx
801024c6:	e8 25 27 00 00       	call   80104bf0 <memset>

  if(kmem.use_lock)
801024cb:	8b 15 94 36 11 80    	mov    0x80113694,%edx
801024d1:	83 c4 10             	add    $0x10,%esp
801024d4:	85 d2                	test   %edx,%edx
801024d6:	75 20                	jne    801024f8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024d8:	a1 98 36 11 80       	mov    0x80113698,%eax
801024dd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024df:	a1 94 36 11 80       	mov    0x80113694,%eax
  kmem.freelist = r;
801024e4:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
801024ea:	85 c0                	test   %eax,%eax
801024ec:	75 22                	jne    80102510 <kfree+0x80>
    release(&kmem.lock);
}
801024ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024f1:	c9                   	leave  
801024f2:	c3                   	ret    
801024f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f7:	90                   	nop
    acquire(&kmem.lock);
801024f8:	83 ec 0c             	sub    $0xc,%esp
801024fb:	68 60 36 11 80       	push   $0x80113660
80102500:	e8 db 25 00 00       	call   80104ae0 <acquire>
80102505:	83 c4 10             	add    $0x10,%esp
80102508:	eb ce                	jmp    801024d8 <kfree+0x48>
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102510:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102517:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251a:	c9                   	leave  
    release(&kmem.lock);
8010251b:	e9 80 26 00 00       	jmp    80104ba0 <release>
    panic("kfree");
80102520:	83 ec 0c             	sub    $0xc,%esp
80102523:	68 66 79 10 80       	push   $0x80107966
80102528:	e8 63 de ff ff       	call   80100390 <panic>
8010252d:	8d 76 00             	lea    0x0(%esi),%esi

80102530 <freerange>:
{
80102530:	f3 0f 1e fb          	endbr32 
80102534:	55                   	push   %ebp
80102535:	89 e5                	mov    %esp,%ebp
80102537:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102538:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010253b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010253e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010253f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102545:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102551:	39 de                	cmp    %ebx,%esi
80102553:	72 1f                	jb     80102574 <freerange+0x44>
80102555:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102558:	83 ec 0c             	sub    $0xc,%esp
8010255b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102561:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102567:	50                   	push   %eax
80102568:	e8 23 ff ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	39 f3                	cmp    %esi,%ebx
80102572:	76 e4                	jbe    80102558 <freerange+0x28>
}
80102574:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102577:	5b                   	pop    %ebx
80102578:	5e                   	pop    %esi
80102579:	5d                   	pop    %ebp
8010257a:	c3                   	ret    
8010257b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010257f:	90                   	nop

80102580 <kinit1>:
{
80102580:	f3 0f 1e fb          	endbr32 
80102584:	55                   	push   %ebp
80102585:	89 e5                	mov    %esp,%ebp
80102587:	56                   	push   %esi
80102588:	53                   	push   %ebx
80102589:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010258c:	83 ec 08             	sub    $0x8,%esp
8010258f:	68 6c 79 10 80       	push   $0x8010796c
80102594:	68 60 36 11 80       	push   $0x80113660
80102599:	e8 c2 23 00 00       	call   80104960 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025a4:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
801025ab:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025ae:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025b4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	72 20                	jb     801025e4 <kinit1+0x64>
801025c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025c8:	83 ec 0c             	sub    $0xc,%esp
801025cb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025d7:	50                   	push   %eax
801025d8:	e8 b3 fe ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025dd:	83 c4 10             	add    $0x10,%esp
801025e0:	39 de                	cmp    %ebx,%esi
801025e2:	73 e4                	jae    801025c8 <kinit1+0x48>
}
801025e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e7:	5b                   	pop    %ebx
801025e8:	5e                   	pop    %esi
801025e9:	5d                   	pop    %ebp
801025ea:	c3                   	ret    
801025eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025ef:	90                   	nop

801025f0 <kinit2>:
{
801025f0:	f3 0f 1e fb          	endbr32 
801025f4:	55                   	push   %ebp
801025f5:	89 e5                	mov    %esp,%ebp
801025f7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025f8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025fb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025fe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ff:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102605:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102611:	39 de                	cmp    %ebx,%esi
80102613:	72 1f                	jb     80102634 <kinit2+0x44>
80102615:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102618:	83 ec 0c             	sub    $0xc,%esp
8010261b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102621:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102627:	50                   	push   %eax
80102628:	e8 63 fe ff ff       	call   80102490 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010262d:	83 c4 10             	add    $0x10,%esp
80102630:	39 de                	cmp    %ebx,%esi
80102632:	73 e4                	jae    80102618 <kinit2+0x28>
  kmem.use_lock = 1;
80102634:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
8010263b:	00 00 00 
}
8010263e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102641:	5b                   	pop    %ebx
80102642:	5e                   	pop    %esi
80102643:	5d                   	pop    %ebp
80102644:	c3                   	ret    
80102645:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010264c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102650 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102650:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102654:	a1 94 36 11 80       	mov    0x80113694,%eax
80102659:	85 c0                	test   %eax,%eax
8010265b:	75 1b                	jne    80102678 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010265d:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
80102662:	85 c0                	test   %eax,%eax
80102664:	74 0a                	je     80102670 <kalloc+0x20>
    kmem.freelist = r->next;
80102666:	8b 10                	mov    (%eax),%edx
80102668:	89 15 98 36 11 80    	mov    %edx,0x80113698
  if(kmem.use_lock)
8010266e:	c3                   	ret    
8010266f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102670:	c3                   	ret    
80102671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102678:	55                   	push   %ebp
80102679:	89 e5                	mov    %esp,%ebp
8010267b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010267e:	68 60 36 11 80       	push   $0x80113660
80102683:	e8 58 24 00 00       	call   80104ae0 <acquire>
  r = kmem.freelist;
80102688:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(r)
8010268d:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102693:	83 c4 10             	add    $0x10,%esp
80102696:	85 c0                	test   %eax,%eax
80102698:	74 08                	je     801026a2 <kalloc+0x52>
    kmem.freelist = r->next;
8010269a:	8b 08                	mov    (%eax),%ecx
8010269c:	89 0d 98 36 11 80    	mov    %ecx,0x80113698
  if(kmem.use_lock)
801026a2:	85 d2                	test   %edx,%edx
801026a4:	74 16                	je     801026bc <kalloc+0x6c>
    release(&kmem.lock);
801026a6:	83 ec 0c             	sub    $0xc,%esp
801026a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ac:	68 60 36 11 80       	push   $0x80113660
801026b1:	e8 ea 24 00 00       	call   80104ba0 <release>
  return (char*)r;
801026b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026b9:	83 c4 10             	add    $0x10,%esp
}
801026bc:	c9                   	leave  
801026bd:	c3                   	ret    
801026be:	66 90                	xchg   %ax,%ax

801026c0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026c0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c4:	ba 64 00 00 00       	mov    $0x64,%edx
801026c9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ca:	a8 01                	test   $0x1,%al
801026cc:	0f 84 be 00 00 00    	je     80102790 <kbdgetc+0xd0>
{
801026d2:	55                   	push   %ebp
801026d3:	ba 60 00 00 00       	mov    $0x60,%edx
801026d8:	89 e5                	mov    %esp,%ebp
801026da:	53                   	push   %ebx
801026db:	ec                   	in     (%dx),%al
  return data;
801026dc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026e2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026e5:	3c e0                	cmp    $0xe0,%al
801026e7:	74 57                	je     80102740 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026e9:	89 d9                	mov    %ebx,%ecx
801026eb:	83 e1 40             	and    $0x40,%ecx
801026ee:	84 c0                	test   %al,%al
801026f0:	78 5e                	js     80102750 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026f2:	85 c9                	test   %ecx,%ecx
801026f4:	74 09                	je     801026ff <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026f6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026f9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026fc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ff:	0f b6 8a a0 7a 10 80 	movzbl -0x7fef8560(%edx),%ecx
  shift ^= togglecode[data];
80102706:	0f b6 82 a0 79 10 80 	movzbl -0x7fef8660(%edx),%eax
  shift |= shiftcode[data];
8010270d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010270f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102711:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102713:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102719:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010271c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010271f:	8b 04 85 80 79 10 80 	mov    -0x7fef8680(,%eax,4),%eax
80102726:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010272a:	74 0b                	je     80102737 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010272c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010272f:	83 fa 19             	cmp    $0x19,%edx
80102732:	77 44                	ja     80102778 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102734:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102737:	5b                   	pop    %ebx
80102738:	5d                   	pop    %ebp
80102739:	c3                   	ret    
8010273a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102740:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102743:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102745:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
8010274d:	c3                   	ret    
8010274e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102750:	83 e0 7f             	and    $0x7f,%eax
80102753:	85 c9                	test   %ecx,%ecx
80102755:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102758:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010275a:	0f b6 8a a0 7a 10 80 	movzbl -0x7fef8560(%edx),%ecx
80102761:	83 c9 40             	or     $0x40,%ecx
80102764:	0f b6 c9             	movzbl %cl,%ecx
80102767:	f7 d1                	not    %ecx
80102769:	21 d9                	and    %ebx,%ecx
}
8010276b:	5b                   	pop    %ebx
8010276c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010276d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102773:	c3                   	ret    
80102774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102778:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010277b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010277e:	5b                   	pop    %ebx
8010277f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102780:	83 f9 1a             	cmp    $0x1a,%ecx
80102783:	0f 42 c2             	cmovb  %edx,%eax
}
80102786:	c3                   	ret    
80102787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278e:	66 90                	xchg   %ax,%ax
    return -1;
80102790:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102795:	c3                   	ret    
80102796:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010279d:	8d 76 00             	lea    0x0(%esi),%esi

801027a0 <kbdintr>:

void
kbdintr(void)
{
801027a0:	f3 0f 1e fb          	endbr32 
801027a4:	55                   	push   %ebp
801027a5:	89 e5                	mov    %esp,%ebp
801027a7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027aa:	68 c0 26 10 80       	push   $0x801026c0
801027af:	e8 ac e0 ff ff       	call   80100860 <consoleintr>
}
801027b4:	83 c4 10             	add    $0x10,%esp
801027b7:	c9                   	leave  
801027b8:	c3                   	ret    
801027b9:	66 90                	xchg   %ax,%ax
801027bb:	66 90                	xchg   %ax,%ax
801027bd:	66 90                	xchg   %ax,%ax
801027bf:	90                   	nop

801027c0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027c0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027c4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801027c9:	85 c0                	test   %eax,%eax
801027cb:	0f 84 c7 00 00 00    	je     80102898 <lapicinit+0xd8>
  lapic[index] = value;
801027d1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027d8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027db:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027de:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027e5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027eb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027f2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ff:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102802:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102805:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010280c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102812:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102819:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010281c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010281f:	8b 50 30             	mov    0x30(%eax),%edx
80102822:	c1 ea 10             	shr    $0x10,%edx
80102825:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010282b:	75 73                	jne    801028a0 <lapicinit+0xe0>
  lapic[index] = value;
8010282d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102834:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102837:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102841:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102847:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010284e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102851:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102854:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010285b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102861:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102868:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102875:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102878:	8b 50 20             	mov    0x20(%eax),%edx
8010287b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102880:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102886:	80 e6 10             	and    $0x10,%dh
80102889:	75 f5                	jne    80102880 <lapicinit+0xc0>
  lapic[index] = value;
8010288b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102892:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102895:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102898:	c3                   	ret    
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028a0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028a7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028aa:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ad:	e9 7b ff ff ff       	jmp    8010282d <lapicinit+0x6d>
801028b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028c0 <lapicid>:

int
lapicid(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028c4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 0b                	je     801028d8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028cd:	8b 40 20             	mov    0x20(%eax),%eax
801028d0:	c1 e8 18             	shr    $0x18,%eax
801028d3:	c3                   	ret    
801028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028d8:	31 c0                	xor    %eax,%eax
}
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028e0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028e4:	a1 9c 36 11 80       	mov    0x8011369c,%eax
801028e9:	85 c0                	test   %eax,%eax
801028eb:	74 0d                	je     801028fa <lapiceoi+0x1a>
  lapic[index] = value;
801028ed:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028fa:	c3                   	ret    
801028fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ff:	90                   	nop

80102900 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102900:	f3 0f 1e fb          	endbr32 
}
80102904:	c3                   	ret    
80102905:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102910 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102910:	f3 0f 1e fb          	endbr32 
80102914:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102915:	b8 0f 00 00 00       	mov    $0xf,%eax
8010291a:	ba 70 00 00 00       	mov    $0x70,%edx
8010291f:	89 e5                	mov    %esp,%ebp
80102921:	53                   	push   %ebx
80102922:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102925:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102928:	ee                   	out    %al,(%dx)
80102929:	b8 0a 00 00 00       	mov    $0xa,%eax
8010292e:	ba 71 00 00 00       	mov    $0x71,%edx
80102933:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102934:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102936:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102939:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010293f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102941:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102944:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102946:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102949:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010294c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102952:	a1 9c 36 11 80       	mov    0x8011369c,%eax
80102957:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010295d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102960:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102967:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010296a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102974:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102977:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102980:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102983:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102989:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010298c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102992:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102995:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010299b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010299c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010299f:	5d                   	pop    %ebp
801029a0:	c3                   	ret    
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029af:	90                   	nop

801029b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029b0:	f3 0f 1e fb          	endbr32 
801029b4:	55                   	push   %ebp
801029b5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029ba:	ba 70 00 00 00       	mov    $0x70,%edx
801029bf:	89 e5                	mov    %esp,%ebp
801029c1:	57                   	push   %edi
801029c2:	56                   	push   %esi
801029c3:	53                   	push   %ebx
801029c4:	83 ec 4c             	sub    $0x4c,%esp
801029c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c8:	ba 71 00 00 00       	mov    $0x71,%edx
801029cd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ce:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029d6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029e0:	31 c0                	xor    %eax,%eax
801029e2:	89 da                	mov    %ebx,%edx
801029e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029ea:	89 ca                	mov    %ecx,%edx
801029ec:	ec                   	in     (%dx),%al
801029ed:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f0:	89 da                	mov    %ebx,%edx
801029f2:	b8 02 00 00 00       	mov    $0x2,%eax
801029f7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f8:	89 ca                	mov    %ecx,%edx
801029fa:	ec                   	in     (%dx),%al
801029fb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fe:	89 da                	mov    %ebx,%edx
80102a00:	b8 04 00 00 00       	mov    $0x4,%eax
80102a05:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a06:	89 ca                	mov    %ecx,%edx
80102a08:	ec                   	in     (%dx),%al
80102a09:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0c:	89 da                	mov    %ebx,%edx
80102a0e:	b8 07 00 00 00       	mov    $0x7,%eax
80102a13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	89 ca                	mov    %ecx,%edx
80102a16:	ec                   	in     (%dx),%al
80102a17:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1a:	89 da                	mov    %ebx,%edx
80102a1c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a21:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a22:	89 ca                	mov    %ecx,%edx
80102a24:	ec                   	in     (%dx),%al
80102a25:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a27:	89 da                	mov    %ebx,%edx
80102a29:	b8 09 00 00 00       	mov    $0x9,%eax
80102a2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2f:	89 ca                	mov    %ecx,%edx
80102a31:	ec                   	in     (%dx),%al
80102a32:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a34:	89 da                	mov    %ebx,%edx
80102a36:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a3c:	89 ca                	mov    %ecx,%edx
80102a3e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a3f:	84 c0                	test   %al,%al
80102a41:	78 9d                	js     801029e0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a43:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a47:	89 fa                	mov    %edi,%edx
80102a49:	0f b6 fa             	movzbl %dl,%edi
80102a4c:	89 f2                	mov    %esi,%edx
80102a4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a51:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a55:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a58:	89 da                	mov    %ebx,%edx
80102a5a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a5d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a60:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a64:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a67:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a6a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a6e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a71:	31 c0                	xor    %eax,%eax
80102a73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a74:	89 ca                	mov    %ecx,%edx
80102a76:	ec                   	in     (%dx),%al
80102a77:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7a:	89 da                	mov    %ebx,%edx
80102a7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a7f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a84:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a85:	89 ca                	mov    %ecx,%edx
80102a87:	ec                   	in     (%dx),%al
80102a88:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8b:	89 da                	mov    %ebx,%edx
80102a8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a90:	b8 04 00 00 00       	mov    $0x4,%eax
80102a95:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a96:	89 ca                	mov    %ecx,%edx
80102a98:	ec                   	in     (%dx),%al
80102a99:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9c:	89 da                	mov    %ebx,%edx
80102a9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102aa1:	b8 07 00 00 00       	mov    $0x7,%eax
80102aa6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa7:	89 ca                	mov    %ecx,%edx
80102aa9:	ec                   	in     (%dx),%al
80102aaa:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aad:	89 da                	mov    %ebx,%edx
80102aaf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ab2:	b8 08 00 00 00       	mov    $0x8,%eax
80102ab7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab8:	89 ca                	mov    %ecx,%edx
80102aba:	ec                   	in     (%dx),%al
80102abb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abe:	89 da                	mov    %ebx,%edx
80102ac0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ac3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ac8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac9:	89 ca                	mov    %ecx,%edx
80102acb:	ec                   	in     (%dx),%al
80102acc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102acf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ad2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ad5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ad8:	6a 18                	push   $0x18
80102ada:	50                   	push   %eax
80102adb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ade:	50                   	push   %eax
80102adf:	e8 5c 21 00 00       	call   80104c40 <memcmp>
80102ae4:	83 c4 10             	add    $0x10,%esp
80102ae7:	85 c0                	test   %eax,%eax
80102ae9:	0f 85 f1 fe ff ff    	jne    801029e0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102aef:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102af3:	75 78                	jne    80102b6d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102af5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102af8:	89 c2                	mov    %eax,%edx
80102afa:	83 e0 0f             	and    $0xf,%eax
80102afd:	c1 ea 04             	shr    $0x4,%edx
80102b00:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b03:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b06:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b09:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b0c:	89 c2                	mov    %eax,%edx
80102b0e:	83 e0 0f             	and    $0xf,%eax
80102b11:	c1 ea 04             	shr    $0x4,%edx
80102b14:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b17:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b1d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b20:	89 c2                	mov    %eax,%edx
80102b22:	83 e0 0f             	and    $0xf,%eax
80102b25:	c1 ea 04             	shr    $0x4,%edx
80102b28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b2e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b31:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b34:	89 c2                	mov    %eax,%edx
80102b36:	83 e0 0f             	and    $0xf,%eax
80102b39:	c1 ea 04             	shr    $0x4,%edx
80102b3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b42:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b45:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b48:	89 c2                	mov    %eax,%edx
80102b4a:	83 e0 0f             	and    $0xf,%eax
80102b4d:	c1 ea 04             	shr    $0x4,%edx
80102b50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b56:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b59:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b5c:	89 c2                	mov    %eax,%edx
80102b5e:	83 e0 0f             	and    $0xf,%eax
80102b61:	c1 ea 04             	shr    $0x4,%edx
80102b64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b6d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b70:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b73:	89 06                	mov    %eax,(%esi)
80102b75:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b78:	89 46 04             	mov    %eax,0x4(%esi)
80102b7b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b7e:	89 46 08             	mov    %eax,0x8(%esi)
80102b81:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b84:	89 46 0c             	mov    %eax,0xc(%esi)
80102b87:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b8a:	89 46 10             	mov    %eax,0x10(%esi)
80102b8d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b90:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b93:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b9d:	5b                   	pop    %ebx
80102b9e:	5e                   	pop    %esi
80102b9f:	5f                   	pop    %edi
80102ba0:	5d                   	pop    %ebp
80102ba1:	c3                   	ret    
80102ba2:	66 90                	xchg   %ax,%ax
80102ba4:	66 90                	xchg   %ax,%ax
80102ba6:	66 90                	xchg   %ax,%ax
80102ba8:	66 90                	xchg   %ax,%ax
80102baa:	66 90                	xchg   %ax,%ax
80102bac:	66 90                	xchg   %ax,%ax
80102bae:	66 90                	xchg   %ax,%ax

80102bb0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bb0:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102bb6:	85 c9                	test   %ecx,%ecx
80102bb8:	0f 8e 8a 00 00 00    	jle    80102c48 <install_trans+0x98>
{
80102bbe:	55                   	push   %ebp
80102bbf:	89 e5                	mov    %esp,%ebp
80102bc1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bc2:	31 ff                	xor    %edi,%edi
{
80102bc4:	56                   	push   %esi
80102bc5:	53                   	push   %ebx
80102bc6:	83 ec 0c             	sub    $0xc,%esp
80102bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bd0:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102bd5:	83 ec 08             	sub    $0x8,%esp
80102bd8:	01 f8                	add    %edi,%eax
80102bda:	83 c0 01             	add    $0x1,%eax
80102bdd:	50                   	push   %eax
80102bde:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102be4:	e8 e7 d4 ff ff       	call   801000d0 <bread>
80102be9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102beb:	58                   	pop    %eax
80102bec:	5a                   	pop    %edx
80102bed:	ff 34 bd ec 36 11 80 	pushl  -0x7feec914(,%edi,4)
80102bf4:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bfa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfd:	e8 ce d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c02:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c05:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c07:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c0a:	68 00 02 00 00       	push   $0x200
80102c0f:	50                   	push   %eax
80102c10:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c13:	50                   	push   %eax
80102c14:	e8 77 20 00 00       	call   80104c90 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 8f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c21:	89 34 24             	mov    %esi,(%esp)
80102c24:	e8 c7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c29:	89 1c 24             	mov    %ebx,(%esp)
80102c2c:	e8 bf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c31:	83 c4 10             	add    $0x10,%esp
80102c34:	39 3d e8 36 11 80    	cmp    %edi,0x801136e8
80102c3a:	7f 94                	jg     80102bd0 <install_trans+0x20>
  }
}
80102c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c3f:	5b                   	pop    %ebx
80102c40:	5e                   	pop    %esi
80102c41:	5f                   	pop    %edi
80102c42:	5d                   	pop    %ebp
80102c43:	c3                   	ret    
80102c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c48:	c3                   	ret    
80102c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	53                   	push   %ebx
80102c54:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c57:	ff 35 d4 36 11 80    	pushl  0x801136d4
80102c5d:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102c63:	e8 68 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c68:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c6b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c6d:	a1 e8 36 11 80       	mov    0x801136e8,%eax
80102c72:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c75:	85 c0                	test   %eax,%eax
80102c77:	7e 19                	jle    80102c92 <write_head+0x42>
80102c79:	31 d2                	xor    %edx,%edx
80102c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c7f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c80:	8b 0c 95 ec 36 11 80 	mov    -0x7feec914(,%edx,4),%ecx
80102c87:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c8b:	83 c2 01             	add    $0x1,%edx
80102c8e:	39 d0                	cmp    %edx,%eax
80102c90:	75 ee                	jne    80102c80 <write_head+0x30>
  }
  bwrite(buf);
80102c92:	83 ec 0c             	sub    $0xc,%esp
80102c95:	53                   	push   %ebx
80102c96:	e8 15 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c9b:	89 1c 24             	mov    %ebx,(%esp)
80102c9e:	e8 4d d5 ff ff       	call   801001f0 <brelse>
}
80102ca3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ca6:	83 c4 10             	add    $0x10,%esp
80102ca9:	c9                   	leave  
80102caa:	c3                   	ret    
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop

80102cb0 <initlog>:
{
80102cb0:	f3 0f 1e fb          	endbr32 
80102cb4:	55                   	push   %ebp
80102cb5:	89 e5                	mov    %esp,%ebp
80102cb7:	53                   	push   %ebx
80102cb8:	83 ec 2c             	sub    $0x2c,%esp
80102cbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cbe:	68 a0 7b 10 80       	push   $0x80107ba0
80102cc3:	68 a0 36 11 80       	push   $0x801136a0
80102cc8:	e8 93 1c 00 00       	call   80104960 <initlock>
  readsb(dev, &sb);
80102ccd:	58                   	pop    %eax
80102cce:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 47 e8 ff ff       	call   80101520 <readsb>
  log.start = sb.logstart;
80102cd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cdc:	59                   	pop    %ecx
  log.dev = dev;
80102cdd:	89 1d e4 36 11 80    	mov    %ebx,0x801136e4
  log.size = sb.nlog;
80102ce3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ce6:	a3 d4 36 11 80       	mov    %eax,0x801136d4
  log.size = sb.nlog;
80102ceb:	89 15 d8 36 11 80    	mov    %edx,0x801136d8
  struct buf *buf = bread(log.dev, log.start);
80102cf1:	5a                   	pop    %edx
80102cf2:	50                   	push   %eax
80102cf3:	53                   	push   %ebx
80102cf4:	e8 d7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cf9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cfc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cff:	89 0d e8 36 11 80    	mov    %ecx,0x801136e8
  for (i = 0; i < log.lh.n; i++) {
80102d05:	85 c9                	test   %ecx,%ecx
80102d07:	7e 19                	jle    80102d22 <initlog+0x72>
80102d09:	31 d2                	xor    %edx,%edx
80102d0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d0f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d10:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d14:	89 1c 95 ec 36 11 80 	mov    %ebx,-0x7feec914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d1b:	83 c2 01             	add    $0x1,%edx
80102d1e:	39 d1                	cmp    %edx,%ecx
80102d20:	75 ee                	jne    80102d10 <initlog+0x60>
  brelse(buf);
80102d22:	83 ec 0c             	sub    $0xc,%esp
80102d25:	50                   	push   %eax
80102d26:	e8 c5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d2b:	e8 80 fe ff ff       	call   80102bb0 <install_trans>
  log.lh.n = 0;
80102d30:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102d37:	00 00 00 
  write_head(); // clear the log
80102d3a:	e8 11 ff ff ff       	call   80102c50 <write_head>
}
80102d3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d42:	83 c4 10             	add    $0x10,%esp
80102d45:	c9                   	leave  
80102d46:	c3                   	ret    
80102d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d4e:	66 90                	xchg   %ax,%ax

80102d50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d50:	f3 0f 1e fb          	endbr32 
80102d54:	55                   	push   %ebp
80102d55:	89 e5                	mov    %esp,%ebp
80102d57:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d5a:	68 a0 36 11 80       	push   $0x801136a0
80102d5f:	e8 7c 1d 00 00       	call   80104ae0 <acquire>
80102d64:	83 c4 10             	add    $0x10,%esp
80102d67:	eb 1c                	jmp    80102d85 <begin_op+0x35>
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d70:	83 ec 08             	sub    $0x8,%esp
80102d73:	68 a0 36 11 80       	push   $0x801136a0
80102d78:	68 a0 36 11 80       	push   $0x801136a0
80102d7d:	e8 6e 13 00 00       	call   801040f0 <sleep>
80102d82:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d85:	a1 e0 36 11 80       	mov    0x801136e0,%eax
80102d8a:	85 c0                	test   %eax,%eax
80102d8c:	75 e2                	jne    80102d70 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d8e:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102d93:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102d99:	83 c0 01             	add    $0x1,%eax
80102d9c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d9f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102da2:	83 fa 1e             	cmp    $0x1e,%edx
80102da5:	7f c9                	jg     80102d70 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102da7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102daa:	a3 dc 36 11 80       	mov    %eax,0x801136dc
      release(&log.lock);
80102daf:	68 a0 36 11 80       	push   $0x801136a0
80102db4:	e8 e7 1d 00 00       	call   80104ba0 <release>
      break;
    }
  }
}
80102db9:	83 c4 10             	add    $0x10,%esp
80102dbc:	c9                   	leave  
80102dbd:	c3                   	ret    
80102dbe:	66 90                	xchg   %ax,%ax

80102dc0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dc0:	f3 0f 1e fb          	endbr32 
80102dc4:	55                   	push   %ebp
80102dc5:	89 e5                	mov    %esp,%ebp
80102dc7:	57                   	push   %edi
80102dc8:	56                   	push   %esi
80102dc9:	53                   	push   %ebx
80102dca:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dcd:	68 a0 36 11 80       	push   $0x801136a0
80102dd2:	e8 09 1d 00 00       	call   80104ae0 <acquire>
  log.outstanding -= 1;
80102dd7:	a1 dc 36 11 80       	mov    0x801136dc,%eax
  if(log.committing)
80102ddc:	8b 35 e0 36 11 80    	mov    0x801136e0,%esi
80102de2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102de5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102de8:	89 1d dc 36 11 80    	mov    %ebx,0x801136dc
  if(log.committing)
80102dee:	85 f6                	test   %esi,%esi
80102df0:	0f 85 1e 01 00 00    	jne    80102f14 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102df6:	85 db                	test   %ebx,%ebx
80102df8:	0f 85 f2 00 00 00    	jne    80102ef0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dfe:	c7 05 e0 36 11 80 01 	movl   $0x1,0x801136e0
80102e05:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e08:	83 ec 0c             	sub    $0xc,%esp
80102e0b:	68 a0 36 11 80       	push   $0x801136a0
80102e10:	e8 8b 1d 00 00       	call   80104ba0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e15:	8b 0d e8 36 11 80    	mov    0x801136e8,%ecx
80102e1b:	83 c4 10             	add    $0x10,%esp
80102e1e:	85 c9                	test   %ecx,%ecx
80102e20:	7f 3e                	jg     80102e60 <end_op+0xa0>
    acquire(&log.lock);
80102e22:	83 ec 0c             	sub    $0xc,%esp
80102e25:	68 a0 36 11 80       	push   $0x801136a0
80102e2a:	e8 b1 1c 00 00       	call   80104ae0 <acquire>
    wakeup(&log);
80102e2f:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
    log.committing = 0;
80102e36:	c7 05 e0 36 11 80 00 	movl   $0x0,0x801136e0
80102e3d:	00 00 00 
    wakeup(&log);
80102e40:	e8 cb 14 00 00       	call   80104310 <wakeup>
    release(&log.lock);
80102e45:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102e4c:	e8 4f 1d 00 00       	call   80104ba0 <release>
80102e51:	83 c4 10             	add    $0x10,%esp
}
80102e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e57:	5b                   	pop    %ebx
80102e58:	5e                   	pop    %esi
80102e59:	5f                   	pop    %edi
80102e5a:	5d                   	pop    %ebp
80102e5b:	c3                   	ret    
80102e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e60:	a1 d4 36 11 80       	mov    0x801136d4,%eax
80102e65:	83 ec 08             	sub    $0x8,%esp
80102e68:	01 d8                	add    %ebx,%eax
80102e6a:	83 c0 01             	add    $0x1,%eax
80102e6d:	50                   	push   %eax
80102e6e:	ff 35 e4 36 11 80    	pushl  0x801136e4
80102e74:	e8 57 d2 ff ff       	call   801000d0 <bread>
80102e79:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7b:	58                   	pop    %eax
80102e7c:	5a                   	pop    %edx
80102e7d:	ff 34 9d ec 36 11 80 	pushl  -0x7feec914(,%ebx,4)
80102e84:	ff 35 e4 36 11 80    	pushl  0x801136e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e8a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e8d:	e8 3e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e92:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e95:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e97:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e9a:	68 00 02 00 00       	push   $0x200
80102e9f:	50                   	push   %eax
80102ea0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ea3:	50                   	push   %eax
80102ea4:	e8 e7 1d 00 00       	call   80104c90 <memmove>
    bwrite(to);  // write the log
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 ff d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102eb1:	89 3c 24             	mov    %edi,(%esp)
80102eb4:	e8 37 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102eb9:	89 34 24             	mov    %esi,(%esp)
80102ebc:	e8 2f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ec1:	83 c4 10             	add    $0x10,%esp
80102ec4:	3b 1d e8 36 11 80    	cmp    0x801136e8,%ebx
80102eca:	7c 94                	jl     80102e60 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ecc:	e8 7f fd ff ff       	call   80102c50 <write_head>
    install_trans(); // Now install writes to home locations
80102ed1:	e8 da fc ff ff       	call   80102bb0 <install_trans>
    log.lh.n = 0;
80102ed6:	c7 05 e8 36 11 80 00 	movl   $0x0,0x801136e8
80102edd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ee0:	e8 6b fd ff ff       	call   80102c50 <write_head>
80102ee5:	e9 38 ff ff ff       	jmp    80102e22 <end_op+0x62>
80102eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ef0:	83 ec 0c             	sub    $0xc,%esp
80102ef3:	68 a0 36 11 80       	push   $0x801136a0
80102ef8:	e8 13 14 00 00       	call   80104310 <wakeup>
  release(&log.lock);
80102efd:	c7 04 24 a0 36 11 80 	movl   $0x801136a0,(%esp)
80102f04:	e8 97 1c 00 00       	call   80104ba0 <release>
80102f09:	83 c4 10             	add    $0x10,%esp
}
80102f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f0f:	5b                   	pop    %ebx
80102f10:	5e                   	pop    %esi
80102f11:	5f                   	pop    %edi
80102f12:	5d                   	pop    %ebp
80102f13:	c3                   	ret    
    panic("log.committing");
80102f14:	83 ec 0c             	sub    $0xc,%esp
80102f17:	68 a4 7b 10 80       	push   $0x80107ba4
80102f1c:	e8 6f d4 ff ff       	call   80100390 <panic>
80102f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f2f:	90                   	nop

80102f30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f30:	f3 0f 1e fb          	endbr32 
80102f34:	55                   	push   %ebp
80102f35:	89 e5                	mov    %esp,%ebp
80102f37:	53                   	push   %ebx
80102f38:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f3b:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
{
80102f41:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f44:	83 fa 1d             	cmp    $0x1d,%edx
80102f47:	0f 8f 91 00 00 00    	jg     80102fde <log_write+0xae>
80102f4d:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102f52:	83 e8 01             	sub    $0x1,%eax
80102f55:	39 c2                	cmp    %eax,%edx
80102f57:	0f 8d 81 00 00 00    	jge    80102fde <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f5d:	a1 dc 36 11 80       	mov    0x801136dc,%eax
80102f62:	85 c0                	test   %eax,%eax
80102f64:	0f 8e 81 00 00 00    	jle    80102feb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f6a:	83 ec 0c             	sub    $0xc,%esp
80102f6d:	68 a0 36 11 80       	push   $0x801136a0
80102f72:	e8 69 1b 00 00       	call   80104ae0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f77:	8b 15 e8 36 11 80    	mov    0x801136e8,%edx
80102f7d:	83 c4 10             	add    $0x10,%esp
80102f80:	85 d2                	test   %edx,%edx
80102f82:	7e 4e                	jle    80102fd2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f84:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f87:	31 c0                	xor    %eax,%eax
80102f89:	eb 0c                	jmp    80102f97 <log_write+0x67>
80102f8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f8f:	90                   	nop
80102f90:	83 c0 01             	add    $0x1,%eax
80102f93:	39 c2                	cmp    %eax,%edx
80102f95:	74 29                	je     80102fc0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f97:	39 0c 85 ec 36 11 80 	cmp    %ecx,-0x7feec914(,%eax,4)
80102f9e:	75 f0                	jne    80102f90 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 85 ec 36 11 80 	mov    %ecx,-0x7feec914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fa7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102faa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fad:	c7 45 08 a0 36 11 80 	movl   $0x801136a0,0x8(%ebp)
}
80102fb4:	c9                   	leave  
  release(&log.lock);
80102fb5:	e9 e6 1b 00 00       	jmp    80104ba0 <release>
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fc0:	89 0c 95 ec 36 11 80 	mov    %ecx,-0x7feec914(,%edx,4)
    log.lh.n++;
80102fc7:	83 c2 01             	add    $0x1,%edx
80102fca:	89 15 e8 36 11 80    	mov    %edx,0x801136e8
80102fd0:	eb d5                	jmp    80102fa7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fd2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fd5:	a3 ec 36 11 80       	mov    %eax,0x801136ec
  if (i == log.lh.n)
80102fda:	75 cb                	jne    80102fa7 <log_write+0x77>
80102fdc:	eb e9                	jmp    80102fc7 <log_write+0x97>
    panic("too big a transaction");
80102fde:	83 ec 0c             	sub    $0xc,%esp
80102fe1:	68 b3 7b 10 80       	push   $0x80107bb3
80102fe6:	e8 a5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102feb:	83 ec 0c             	sub    $0xc,%esp
80102fee:	68 c9 7b 10 80       	push   $0x80107bc9
80102ff3:	e8 98 d3 ff ff       	call   80100390 <panic>
80102ff8:	66 90                	xchg   %ax,%ax
80102ffa:	66 90                	xchg   %ax,%ax
80102ffc:	66 90                	xchg   %ax,%ax
80102ffe:	66 90                	xchg   %ax,%ax

80103000 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	53                   	push   %ebx
80103004:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103007:	e8 84 09 00 00       	call   80103990 <cpuid>
8010300c:	89 c3                	mov    %eax,%ebx
8010300e:	e8 7d 09 00 00       	call   80103990 <cpuid>
80103013:	83 ec 04             	sub    $0x4,%esp
80103016:	53                   	push   %ebx
80103017:	50                   	push   %eax
80103018:	68 e4 7b 10 80       	push   $0x80107be4
8010301d:	e8 8e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103022:	e8 09 2f 00 00       	call   80105f30 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103027:	e8 f4 08 00 00       	call   80103920 <mycpu>
8010302c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010302e:	b8 01 00 00 00       	mov    $0x1,%eax
80103033:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010303a:	e8 b1 0d 00 00       	call   80103df0 <scheduler>
8010303f:	90                   	nop

80103040 <mpenter>:
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	55                   	push   %ebp
80103045:	89 e5                	mov    %esp,%ebp
80103047:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010304a:	e8 b1 3f 00 00       	call   80107000 <switchkvm>
  seginit();
8010304f:	e8 1c 3f 00 00       	call   80106f70 <seginit>
  lapicinit();
80103054:	e8 67 f7 ff ff       	call   801027c0 <lapicinit>
  mpmain();
80103059:	e8 a2 ff ff ff       	call   80103000 <mpmain>
8010305e:	66 90                	xchg   %ax,%ax

80103060 <main>:
{
80103060:	f3 0f 1e fb          	endbr32 
80103064:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103068:	83 e4 f0             	and    $0xfffffff0,%esp
8010306b:	ff 71 fc             	pushl  -0x4(%ecx)
8010306e:	55                   	push   %ebp
8010306f:	89 e5                	mov    %esp,%ebp
80103071:	53                   	push   %ebx
80103072:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103073:	83 ec 08             	sub    $0x8,%esp
80103076:	68 00 00 40 80       	push   $0x80400000
8010307b:	68 08 68 11 80       	push   $0x80116808
80103080:	e8 fb f4 ff ff       	call   80102580 <kinit1>
  kvmalloc();      // kernel page table
80103085:	e8 56 44 00 00       	call   801074e0 <kvmalloc>
  mpinit();        // detect other processors
8010308a:	e8 81 01 00 00       	call   80103210 <mpinit>
  lapicinit();     // interrupt controller
8010308f:	e8 2c f7 ff ff       	call   801027c0 <lapicinit>
  seginit();       // segment descriptors
80103094:	e8 d7 3e 00 00       	call   80106f70 <seginit>
  picinit();       // disable pic
80103099:	e8 52 03 00 00       	call   801033f0 <picinit>
  ioapicinit();    // another interrupt controller
8010309e:	e8 fd f2 ff ff       	call   801023a0 <ioapicinit>
  consoleinit();   // console hardware
801030a3:	e8 88 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030a8:	e8 83 31 00 00       	call   80106230 <uartinit>
  pinit();         // process table
801030ad:	e8 3e 08 00 00       	call   801038f0 <pinit>
  tvinit();        // trap vectors
801030b2:	e8 f9 2d 00 00       	call   80105eb0 <tvinit>
  binit();         // buffer cache
801030b7:	e8 84 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030bc:	e8 3f dd ff ff       	call   80100e00 <fileinit>
  ideinit();       // disk 
801030c1:	e8 aa f0 ff ff       	call   80102170 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030c6:	83 c4 0c             	add    $0xc,%esp
801030c9:	68 8a 00 00 00       	push   $0x8a
801030ce:	68 8c b4 10 80       	push   $0x8010b48c
801030d3:	68 00 70 00 80       	push   $0x80007000
801030d8:	e8 b3 1b 00 00       	call   80104c90 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030dd:	83 c4 10             	add    $0x10,%esp
801030e0:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
801030e7:	00 00 00 
801030ea:	05 a0 37 11 80       	add    $0x801137a0,%eax
801030ef:	3d a0 37 11 80       	cmp    $0x801137a0,%eax
801030f4:	76 7a                	jbe    80103170 <main+0x110>
801030f6:	bb a0 37 11 80       	mov    $0x801137a0,%ebx
801030fb:	eb 1c                	jmp    80103119 <main+0xb9>
801030fd:	8d 76 00             	lea    0x0(%esi),%esi
80103100:	69 05 20 3d 11 80 b0 	imul   $0xb0,0x80113d20,%eax
80103107:	00 00 00 
8010310a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103110:	05 a0 37 11 80       	add    $0x801137a0,%eax
80103115:	39 c3                	cmp    %eax,%ebx
80103117:	73 57                	jae    80103170 <main+0x110>
    if(c == mycpu())  // We've started already.
80103119:	e8 02 08 00 00       	call   80103920 <mycpu>
8010311e:	39 c3                	cmp    %eax,%ebx
80103120:	74 de                	je     80103100 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103122:	e8 29 f5 ff ff       	call   80102650 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103127:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010312a:	c7 05 f8 6f 00 80 40 	movl   $0x80103040,0x80006ff8
80103131:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103134:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010313b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010313e:	05 00 10 00 00       	add    $0x1000,%eax
80103143:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103148:	0f b6 03             	movzbl (%ebx),%eax
8010314b:	68 00 70 00 00       	push   $0x7000
80103150:	50                   	push   %eax
80103151:	e8 ba f7 ff ff       	call   80102910 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103156:	83 c4 10             	add    $0x10,%esp
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103160:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103166:	85 c0                	test   %eax,%eax
80103168:	74 f6                	je     80103160 <main+0x100>
8010316a:	eb 94                	jmp    80103100 <main+0xa0>
8010316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103170:	83 ec 08             	sub    $0x8,%esp
80103173:	68 00 00 00 8e       	push   $0x8e000000
80103178:	68 00 00 40 80       	push   $0x80400000
8010317d:	e8 6e f4 ff ff       	call   801025f0 <kinit2>
  userinit();      // first user process
80103182:	e8 59 08 00 00       	call   801039e0 <userinit>
  mpmain();        // finish this processor's setup
80103187:	e8 74 fe ff ff       	call   80103000 <mpmain>
8010318c:	66 90                	xchg   %ax,%ax
8010318e:	66 90                	xchg   %ax,%ax

80103190 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103190:	55                   	push   %ebp
80103191:	89 e5                	mov    %esp,%ebp
80103193:	57                   	push   %edi
80103194:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103195:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010319b:	53                   	push   %ebx
  e = addr+len;
8010319c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010319f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031a2:	39 de                	cmp    %ebx,%esi
801031a4:	72 10                	jb     801031b6 <mpsearch1+0x26>
801031a6:	eb 50                	jmp    801031f8 <mpsearch1+0x68>
801031a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop
801031b0:	89 fe                	mov    %edi,%esi
801031b2:	39 fb                	cmp    %edi,%ebx
801031b4:	76 42                	jbe    801031f8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031b6:	83 ec 04             	sub    $0x4,%esp
801031b9:	8d 7e 10             	lea    0x10(%esi),%edi
801031bc:	6a 04                	push   $0x4
801031be:	68 f8 7b 10 80       	push   $0x80107bf8
801031c3:	56                   	push   %esi
801031c4:	e8 77 1a 00 00       	call   80104c40 <memcmp>
801031c9:	83 c4 10             	add    $0x10,%esp
801031cc:	85 c0                	test   %eax,%eax
801031ce:	75 e0                	jne    801031b0 <mpsearch1+0x20>
801031d0:	89 f2                	mov    %esi,%edx
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031d8:	0f b6 0a             	movzbl (%edx),%ecx
801031db:	83 c2 01             	add    $0x1,%edx
801031de:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031e0:	39 fa                	cmp    %edi,%edx
801031e2:	75 f4                	jne    801031d8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e4:	84 c0                	test   %al,%al
801031e6:	75 c8                	jne    801031b0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031eb:	89 f0                	mov    %esi,%eax
801031ed:	5b                   	pop    %ebx
801031ee:	5e                   	pop    %esi
801031ef:	5f                   	pop    %edi
801031f0:	5d                   	pop    %ebp
801031f1:	c3                   	ret    
801031f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031fb:	31 f6                	xor    %esi,%esi
}
801031fd:	5b                   	pop    %ebx
801031fe:	89 f0                	mov    %esi,%eax
80103200:	5e                   	pop    %esi
80103201:	5f                   	pop    %edi
80103202:	5d                   	pop    %ebp
80103203:	c3                   	ret    
80103204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop

80103210 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103210:	f3 0f 1e fb          	endbr32 
80103214:	55                   	push   %ebp
80103215:	89 e5                	mov    %esp,%ebp
80103217:	57                   	push   %edi
80103218:	56                   	push   %esi
80103219:	53                   	push   %ebx
8010321a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010321d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103224:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010322b:	c1 e0 08             	shl    $0x8,%eax
8010322e:	09 d0                	or     %edx,%eax
80103230:	c1 e0 04             	shl    $0x4,%eax
80103233:	75 1b                	jne    80103250 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103235:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010323c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103243:	c1 e0 08             	shl    $0x8,%eax
80103246:	09 d0                	or     %edx,%eax
80103248:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010324b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103250:	ba 00 04 00 00       	mov    $0x400,%edx
80103255:	e8 36 ff ff ff       	call   80103190 <mpsearch1>
8010325a:	89 c6                	mov    %eax,%esi
8010325c:	85 c0                	test   %eax,%eax
8010325e:	0f 84 4c 01 00 00    	je     801033b0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103264:	8b 5e 04             	mov    0x4(%esi),%ebx
80103267:	85 db                	test   %ebx,%ebx
80103269:	0f 84 61 01 00 00    	je     801033d0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010326f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103272:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103278:	6a 04                	push   $0x4
8010327a:	68 fd 7b 10 80       	push   $0x80107bfd
8010327f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103280:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103283:	e8 b8 19 00 00       	call   80104c40 <memcmp>
80103288:	83 c4 10             	add    $0x10,%esp
8010328b:	85 c0                	test   %eax,%eax
8010328d:	0f 85 3d 01 00 00    	jne    801033d0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103293:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010329a:	3c 01                	cmp    $0x1,%al
8010329c:	74 08                	je     801032a6 <mpinit+0x96>
8010329e:	3c 04                	cmp    $0x4,%al
801032a0:	0f 85 2a 01 00 00    	jne    801033d0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801032a6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801032ad:	66 85 d2             	test   %dx,%dx
801032b0:	74 26                	je     801032d8 <mpinit+0xc8>
801032b2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032b5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032b7:	31 d2                	xor    %edx,%edx
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032c0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032c7:	83 c0 01             	add    $0x1,%eax
801032ca:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032cc:	39 f8                	cmp    %edi,%eax
801032ce:	75 f0                	jne    801032c0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032d0:	84 d2                	test   %dl,%dl
801032d2:	0f 85 f8 00 00 00    	jne    801033d0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032d8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032de:	a3 9c 36 11 80       	mov    %eax,0x8011369c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032e9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032f0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032f8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ff:	90                   	nop
80103300:	39 c2                	cmp    %eax,%edx
80103302:	76 15                	jbe    80103319 <mpinit+0x109>
    switch(*p){
80103304:	0f b6 08             	movzbl (%eax),%ecx
80103307:	80 f9 02             	cmp    $0x2,%cl
8010330a:	74 5c                	je     80103368 <mpinit+0x158>
8010330c:	77 42                	ja     80103350 <mpinit+0x140>
8010330e:	84 c9                	test   %cl,%cl
80103310:	74 6e                	je     80103380 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103312:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103315:	39 c2                	cmp    %eax,%edx
80103317:	77 eb                	ja     80103304 <mpinit+0xf4>
80103319:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010331c:	85 db                	test   %ebx,%ebx
8010331e:	0f 84 b9 00 00 00    	je     801033dd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103324:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103328:	74 15                	je     8010333f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332a:	b8 70 00 00 00       	mov    $0x70,%eax
8010332f:	ba 22 00 00 00       	mov    $0x22,%edx
80103334:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103335:	ba 23 00 00 00       	mov    $0x23,%edx
8010333a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010333b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010333e:	ee                   	out    %al,(%dx)
  }
}
8010333f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103342:	5b                   	pop    %ebx
80103343:	5e                   	pop    %esi
80103344:	5f                   	pop    %edi
80103345:	5d                   	pop    %ebp
80103346:	c3                   	ret    
80103347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010334e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103350:	83 e9 03             	sub    $0x3,%ecx
80103353:	80 f9 01             	cmp    $0x1,%cl
80103356:	76 ba                	jbe    80103312 <mpinit+0x102>
80103358:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010335f:	eb 9f                	jmp    80103300 <mpinit+0xf0>
80103361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103368:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010336c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010336f:	88 0d 80 37 11 80    	mov    %cl,0x80113780
      continue;
80103375:	eb 89                	jmp    80103300 <mpinit+0xf0>
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103380:	8b 0d 20 3d 11 80    	mov    0x80113d20,%ecx
80103386:	83 f9 07             	cmp    $0x7,%ecx
80103389:	7f 19                	jg     801033a4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103391:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103395:	83 c1 01             	add    $0x1,%ecx
80103398:	89 0d 20 3d 11 80    	mov    %ecx,0x80113d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339e:	88 9f a0 37 11 80    	mov    %bl,-0x7feec860(%edi)
      p += sizeof(struct mpproc);
801033a4:	83 c0 14             	add    $0x14,%eax
      continue;
801033a7:	e9 54 ff ff ff       	jmp    80103300 <mpinit+0xf0>
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033b0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033b5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033ba:	e8 d1 fd ff ff       	call   80103190 <mpsearch1>
801033bf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033c1:	85 c0                	test   %eax,%eax
801033c3:	0f 85 9b fe ff ff    	jne    80103264 <mpinit+0x54>
801033c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033d0:	83 ec 0c             	sub    $0xc,%esp
801033d3:	68 02 7c 10 80       	push   $0x80107c02
801033d8:	e8 b3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033dd:	83 ec 0c             	sub    $0xc,%esp
801033e0:	68 1c 7c 10 80       	push   $0x80107c1c
801033e5:	e8 a6 cf ff ff       	call   80100390 <panic>
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033f0:	f3 0f 1e fb          	endbr32 
801033f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033f9:	ba 21 00 00 00       	mov    $0x21,%edx
801033fe:	ee                   	out    %al,(%dx)
801033ff:	ba a1 00 00 00       	mov    $0xa1,%edx
80103404:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103405:	c3                   	ret    
80103406:	66 90                	xchg   %ax,%ax
80103408:	66 90                	xchg   %ax,%ax
8010340a:	66 90                	xchg   %ax,%ax
8010340c:	66 90                	xchg   %ax,%ax
8010340e:	66 90                	xchg   %ax,%ax

80103410 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103410:	f3 0f 1e fb          	endbr32 
80103414:	55                   	push   %ebp
80103415:	89 e5                	mov    %esp,%ebp
80103417:	57                   	push   %edi
80103418:	56                   	push   %esi
80103419:	53                   	push   %ebx
8010341a:	83 ec 0c             	sub    $0xc,%esp
8010341d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103420:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103423:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103429:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010342f:	e8 ec d9 ff ff       	call   80100e20 <filealloc>
80103434:	89 03                	mov    %eax,(%ebx)
80103436:	85 c0                	test   %eax,%eax
80103438:	0f 84 ac 00 00 00    	je     801034ea <pipealloc+0xda>
8010343e:	e8 dd d9 ff ff       	call   80100e20 <filealloc>
80103443:	89 06                	mov    %eax,(%esi)
80103445:	85 c0                	test   %eax,%eax
80103447:	0f 84 8b 00 00 00    	je     801034d8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010344d:	e8 fe f1 ff ff       	call   80102650 <kalloc>
80103452:	89 c7                	mov    %eax,%edi
80103454:	85 c0                	test   %eax,%eax
80103456:	0f 84 b4 00 00 00    	je     80103510 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010345c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103463:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103466:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103469:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103470:	00 00 00 
  p->nwrite = 0;
80103473:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010347a:	00 00 00 
  p->nread = 0;
8010347d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103484:	00 00 00 
  initlock(&p->lock, "pipe");
80103487:	68 3b 7c 10 80       	push   $0x80107c3b
8010348c:	50                   	push   %eax
8010348d:	e8 ce 14 00 00       	call   80104960 <initlock>
  (*f0)->type = FD_PIPE;
80103492:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103494:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103497:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010349d:	8b 03                	mov    (%ebx),%eax
8010349f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034a3:	8b 03                	mov    (%ebx),%eax
801034a5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034a9:	8b 03                	mov    (%ebx),%eax
801034ab:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ae:	8b 06                	mov    (%esi),%eax
801034b0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034b6:	8b 06                	mov    (%esi),%eax
801034b8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034bc:	8b 06                	mov    (%esi),%eax
801034be:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034c2:	8b 06                	mov    (%esi),%eax
801034c4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ca:	31 c0                	xor    %eax,%eax
}
801034cc:	5b                   	pop    %ebx
801034cd:	5e                   	pop    %esi
801034ce:	5f                   	pop    %edi
801034cf:	5d                   	pop    %ebp
801034d0:	c3                   	ret    
801034d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034d8:	8b 03                	mov    (%ebx),%eax
801034da:	85 c0                	test   %eax,%eax
801034dc:	74 1e                	je     801034fc <pipealloc+0xec>
    fileclose(*f0);
801034de:	83 ec 0c             	sub    $0xc,%esp
801034e1:	50                   	push   %eax
801034e2:	e8 f9 d9 ff ff       	call   80100ee0 <fileclose>
801034e7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034ea:	8b 06                	mov    (%esi),%eax
801034ec:	85 c0                	test   %eax,%eax
801034ee:	74 0c                	je     801034fc <pipealloc+0xec>
    fileclose(*f1);
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	50                   	push   %eax
801034f4:	e8 e7 d9 ff ff       	call   80100ee0 <fileclose>
801034f9:	83 c4 10             	add    $0x10,%esp
}
801034fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103504:	5b                   	pop    %ebx
80103505:	5e                   	pop    %esi
80103506:	5f                   	pop    %edi
80103507:	5d                   	pop    %ebp
80103508:	c3                   	ret    
80103509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103510:	8b 03                	mov    (%ebx),%eax
80103512:	85 c0                	test   %eax,%eax
80103514:	75 c8                	jne    801034de <pipealloc+0xce>
80103516:	eb d2                	jmp    801034ea <pipealloc+0xda>
80103518:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010351f:	90                   	nop

80103520 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103520:	f3 0f 1e fb          	endbr32 
80103524:	55                   	push   %ebp
80103525:	89 e5                	mov    %esp,%ebp
80103527:	56                   	push   %esi
80103528:	53                   	push   %ebx
80103529:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010352c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	53                   	push   %ebx
80103533:	e8 a8 15 00 00       	call   80104ae0 <acquire>
  if(writable){
80103538:	83 c4 10             	add    $0x10,%esp
8010353b:	85 f6                	test   %esi,%esi
8010353d:	74 41                	je     80103580 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010353f:	83 ec 0c             	sub    $0xc,%esp
80103542:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103548:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010354f:	00 00 00 
    wakeup(&p->nread);
80103552:	50                   	push   %eax
80103553:	e8 b8 0d 00 00       	call   80104310 <wakeup>
80103558:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010355b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103561:	85 d2                	test   %edx,%edx
80103563:	75 0a                	jne    8010356f <pipeclose+0x4f>
80103565:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010356b:	85 c0                	test   %eax,%eax
8010356d:	74 31                	je     801035a0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010356f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103572:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103575:	5b                   	pop    %ebx
80103576:	5e                   	pop    %esi
80103577:	5d                   	pop    %ebp
    release(&p->lock);
80103578:	e9 23 16 00 00       	jmp    80104ba0 <release>
8010357d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103589:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103590:	00 00 00 
    wakeup(&p->nwrite);
80103593:	50                   	push   %eax
80103594:	e8 77 0d 00 00       	call   80104310 <wakeup>
80103599:	83 c4 10             	add    $0x10,%esp
8010359c:	eb bd                	jmp    8010355b <pipeclose+0x3b>
8010359e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035a0:	83 ec 0c             	sub    $0xc,%esp
801035a3:	53                   	push   %ebx
801035a4:	e8 f7 15 00 00       	call   80104ba0 <release>
    kfree((char*)p);
801035a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ac:	83 c4 10             	add    $0x10,%esp
}
801035af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b2:	5b                   	pop    %ebx
801035b3:	5e                   	pop    %esi
801035b4:	5d                   	pop    %ebp
    kfree((char*)p);
801035b5:	e9 d6 ee ff ff       	jmp    80102490 <kfree>
801035ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035c0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035c0:	f3 0f 1e fb          	endbr32 
801035c4:	55                   	push   %ebp
801035c5:	89 e5                	mov    %esp,%ebp
801035c7:	57                   	push   %edi
801035c8:	56                   	push   %esi
801035c9:	53                   	push   %ebx
801035ca:	83 ec 28             	sub    $0x28,%esp
801035cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035d0:	53                   	push   %ebx
801035d1:	e8 0a 15 00 00       	call   80104ae0 <acquire>
  for(i = 0; i < n; i++){
801035d6:	8b 45 10             	mov    0x10(%ebp),%eax
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	85 c0                	test   %eax,%eax
801035de:	0f 8e bc 00 00 00    	jle    801036a0 <pipewrite+0xe0>
801035e4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035e7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035ed:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035f6:	03 45 10             	add    0x10(%ebp),%eax
801035f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035fc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103602:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103608:	89 ca                	mov    %ecx,%edx
8010360a:	05 00 02 00 00       	add    $0x200,%eax
8010360f:	39 c1                	cmp    %eax,%ecx
80103611:	74 3b                	je     8010364e <pipewrite+0x8e>
80103613:	eb 63                	jmp    80103678 <pipewrite+0xb8>
80103615:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103618:	e8 93 03 00 00       	call   801039b0 <myproc>
8010361d:	8b 48 24             	mov    0x24(%eax),%ecx
80103620:	85 c9                	test   %ecx,%ecx
80103622:	75 34                	jne    80103658 <pipewrite+0x98>
      wakeup(&p->nread);
80103624:	83 ec 0c             	sub    $0xc,%esp
80103627:	57                   	push   %edi
80103628:	e8 e3 0c 00 00       	call   80104310 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010362d:	58                   	pop    %eax
8010362e:	5a                   	pop    %edx
8010362f:	53                   	push   %ebx
80103630:	56                   	push   %esi
80103631:	e8 ba 0a 00 00       	call   801040f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103636:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010363c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103642:	83 c4 10             	add    $0x10,%esp
80103645:	05 00 02 00 00       	add    $0x200,%eax
8010364a:	39 c2                	cmp    %eax,%edx
8010364c:	75 2a                	jne    80103678 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010364e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103654:	85 c0                	test   %eax,%eax
80103656:	75 c0                	jne    80103618 <pipewrite+0x58>
        release(&p->lock);
80103658:	83 ec 0c             	sub    $0xc,%esp
8010365b:	53                   	push   %ebx
8010365c:	e8 3f 15 00 00       	call   80104ba0 <release>
        return -1;
80103661:	83 c4 10             	add    $0x10,%esp
80103664:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103669:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010366c:	5b                   	pop    %ebx
8010366d:	5e                   	pop    %esi
8010366e:	5f                   	pop    %edi
8010366f:	5d                   	pop    %ebp
80103670:	c3                   	ret    
80103671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103678:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010367b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010367e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103684:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010368a:	0f b6 06             	movzbl (%esi),%eax
8010368d:	83 c6 01             	add    $0x1,%esi
80103690:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103693:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103697:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010369a:	0f 85 5c ff ff ff    	jne    801035fc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036a9:	50                   	push   %eax
801036aa:	e8 61 0c 00 00       	call   80104310 <wakeup>
  release(&p->lock);
801036af:	89 1c 24             	mov    %ebx,(%esp)
801036b2:	e8 e9 14 00 00       	call   80104ba0 <release>
  return n;
801036b7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ba:	83 c4 10             	add    $0x10,%esp
801036bd:	eb aa                	jmp    80103669 <pipewrite+0xa9>
801036bf:	90                   	nop

801036c0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036c0:	f3 0f 1e fb          	endbr32 
801036c4:	55                   	push   %ebp
801036c5:	89 e5                	mov    %esp,%ebp
801036c7:	57                   	push   %edi
801036c8:	56                   	push   %esi
801036c9:	53                   	push   %ebx
801036ca:	83 ec 18             	sub    $0x18,%esp
801036cd:	8b 75 08             	mov    0x8(%ebp),%esi
801036d0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036d3:	56                   	push   %esi
801036d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036da:	e8 01 14 00 00       	call   80104ae0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036df:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036e5:	83 c4 10             	add    $0x10,%esp
801036e8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ee:	74 33                	je     80103723 <piperead+0x63>
801036f0:	eb 3b                	jmp    8010372d <piperead+0x6d>
801036f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036f8:	e8 b3 02 00 00       	call   801039b0 <myproc>
801036fd:	8b 48 24             	mov    0x24(%eax),%ecx
80103700:	85 c9                	test   %ecx,%ecx
80103702:	0f 85 88 00 00 00    	jne    80103790 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103708:	83 ec 08             	sub    $0x8,%esp
8010370b:	56                   	push   %esi
8010370c:	53                   	push   %ebx
8010370d:	e8 de 09 00 00       	call   801040f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103712:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103718:	83 c4 10             	add    $0x10,%esp
8010371b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103721:	75 0a                	jne    8010372d <piperead+0x6d>
80103723:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103729:	85 c0                	test   %eax,%eax
8010372b:	75 cb                	jne    801036f8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010372d:	8b 55 10             	mov    0x10(%ebp),%edx
80103730:	31 db                	xor    %ebx,%ebx
80103732:	85 d2                	test   %edx,%edx
80103734:	7f 28                	jg     8010375e <piperead+0x9e>
80103736:	eb 34                	jmp    8010376c <piperead+0xac>
80103738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010373f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103740:	8d 48 01             	lea    0x1(%eax),%ecx
80103743:	25 ff 01 00 00       	and    $0x1ff,%eax
80103748:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010374e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103753:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103756:	83 c3 01             	add    $0x1,%ebx
80103759:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010375c:	74 0e                	je     8010376c <piperead+0xac>
    if(p->nread == p->nwrite)
8010375e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103764:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010376a:	75 d4                	jne    80103740 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010376c:	83 ec 0c             	sub    $0xc,%esp
8010376f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103775:	50                   	push   %eax
80103776:	e8 95 0b 00 00       	call   80104310 <wakeup>
  release(&p->lock);
8010377b:	89 34 24             	mov    %esi,(%esp)
8010377e:	e8 1d 14 00 00       	call   80104ba0 <release>
  return i;
80103783:	83 c4 10             	add    $0x10,%esp
}
80103786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103789:	89 d8                	mov    %ebx,%eax
8010378b:	5b                   	pop    %ebx
8010378c:	5e                   	pop    %esi
8010378d:	5f                   	pop    %edi
8010378e:	5d                   	pop    %ebp
8010378f:	c3                   	ret    
      release(&p->lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103793:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103798:	56                   	push   %esi
80103799:	e8 02 14 00 00       	call   80104ba0 <release>
      return -1;
8010379e:	83 c4 10             	add    $0x10,%esp
}
801037a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037a4:	89 d8                	mov    %ebx,%eax
801037a6:	5b                   	pop    %ebx
801037a7:	5e                   	pop    %esi
801037a8:	5f                   	pop    %edi
801037a9:	5d                   	pop    %ebp
801037aa:	c3                   	ret    
801037ab:	66 90                	xchg   %ax,%ax
801037ad:	66 90                	xchg   %ax,%ax
801037af:	90                   	nop

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  char *sp;
  //p->readid = 0;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb b4 3d 11 80       	mov    $0x80113db4,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 80 3d 11 80       	push   $0x80113d80
801037c1:	e8 1a 13 00 00       	call   80104ae0 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 17                	jmp    801037e2 <allocproc+0x32>
801037cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037cf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801037d6:	81 fb b4 5f 11 80    	cmp    $0x80115fb4,%ebx
801037dc:	0f 84 8e 00 00 00    	je     80103870 <allocproc+0xc0>
    if(p->state == UNUSED)
801037e2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e5:	85 c0                	test   %eax,%eax
801037e7:	75 e7                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->stackTop = -1; // stack top initilization
  p->threads = -1; // threads initialization

  release(&ptable.lock);
801037ee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037f1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->stackTop = -1; // stack top initilization
801037f8:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
801037ff:	ff ff ff 
  p->pid = nextpid++;
80103802:	89 43 10             	mov    %eax,0x10(%ebx)
80103805:	8d 50 01             	lea    0x1(%eax),%edx
  p->threads = -1; // threads initialization
80103808:	c7 83 84 00 00 00 ff 	movl   $0xffffffff,0x84(%ebx)
8010380f:	ff ff ff 
  release(&ptable.lock);
80103812:	68 80 3d 11 80       	push   $0x80113d80
  p->pid = nextpid++;
80103817:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010381d:	e8 7e 13 00 00       	call   80104ba0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103822:	e8 29 ee ff ff       	call   80102650 <kalloc>
80103827:	83 c4 10             	add    $0x10,%esp
8010382a:	89 43 08             	mov    %eax,0x8(%ebx)
8010382d:	85 c0                	test   %eax,%eax
8010382f:	74 58                	je     80103889 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103831:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103837:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010383a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010383f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103842:	c7 40 14 a1 5e 10 80 	movl   $0x80105ea1,0x14(%eax)
  p->context = (struct context*)sp;
80103849:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010384c:	6a 14                	push   $0x14
8010384e:	6a 00                	push   $0x0
80103850:	50                   	push   %eax
80103851:	e8 9a 13 00 00       	call   80104bf0 <memset>
  p->context->eip = (uint)forkret;
80103856:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103859:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010385c:	c7 40 10 a0 38 10 80 	movl   $0x801038a0,0x10(%eax)
}
80103863:	89 d8                	mov    %ebx,%eax
80103865:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103868:	c9                   	leave  
80103869:	c3                   	ret    
8010386a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103873:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103875:	68 80 3d 11 80       	push   $0x80113d80
8010387a:	e8 21 13 00 00       	call   80104ba0 <release>
}
8010387f:	89 d8                	mov    %ebx,%eax
  return 0;
80103881:	83 c4 10             	add    $0x10,%esp
}
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave  
80103888:	c3                   	ret    
    p->state = UNUSED;
80103889:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103890:	31 db                	xor    %ebx,%ebx
}
80103892:	89 d8                	mov    %ebx,%eax
80103894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103897:	c9                   	leave  
80103898:	c3                   	ret    
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038a0:	f3 0f 1e fb          	endbr32 
801038a4:	55                   	push   %ebp
801038a5:	89 e5                	mov    %esp,%ebp
801038a7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038aa:	68 80 3d 11 80       	push   $0x80113d80
801038af:	e8 ec 12 00 00       	call   80104ba0 <release>

  if (first) {
801038b4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038b9:	83 c4 10             	add    $0x10,%esp
801038bc:	85 c0                	test   %eax,%eax
801038be:	75 08                	jne    801038c8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038c0:	c9                   	leave  
801038c1:	c3                   	ret    
801038c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038c8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038cf:	00 00 00 
    iinit(ROOTDEV);
801038d2:	83 ec 0c             	sub    $0xc,%esp
801038d5:	6a 01                	push   $0x1
801038d7:	e8 84 dc ff ff       	call   80101560 <iinit>
    initlog(ROOTDEV);
801038dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038e3:	e8 c8 f3 ff ff       	call   80102cb0 <initlog>
}
801038e8:	83 c4 10             	add    $0x10,%esp
801038eb:	c9                   	leave  
801038ec:	c3                   	ret    
801038ed:	8d 76 00             	lea    0x0(%esi),%esi

801038f0 <pinit>:
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038fa:	68 40 7c 10 80       	push   $0x80107c40
801038ff:	68 80 3d 11 80       	push   $0x80113d80
80103904:	e8 57 10 00 00       	call   80104960 <initlock>
  initlock(&thread, "thread");
80103909:	58                   	pop    %eax
8010390a:	5a                   	pop    %edx
8010390b:	68 47 7c 10 80       	push   $0x80107c47
80103910:	68 40 3d 11 80       	push   $0x80113d40
80103915:	e8 46 10 00 00       	call   80104960 <initlock>
}
8010391a:	83 c4 10             	add    $0x10,%esp
8010391d:	c9                   	leave  
8010391e:	c3                   	ret    
8010391f:	90                   	nop

80103920 <mycpu>:
{
80103920:	f3 0f 1e fb          	endbr32 
80103924:	55                   	push   %ebp
80103925:	89 e5                	mov    %esp,%ebp
80103927:	56                   	push   %esi
80103928:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103929:	9c                   	pushf  
8010392a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010392b:	f6 c4 02             	test   $0x2,%ah
8010392e:	75 4a                	jne    8010397a <mycpu+0x5a>
  apicid = lapicid();
80103930:	e8 8b ef ff ff       	call   801028c0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103935:	8b 35 20 3d 11 80    	mov    0x80113d20,%esi
  apicid = lapicid();
8010393b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010393d:	85 f6                	test   %esi,%esi
8010393f:	7e 2c                	jle    8010396d <mycpu+0x4d>
80103941:	31 d2                	xor    %edx,%edx
80103943:	eb 0a                	jmp    8010394f <mycpu+0x2f>
80103945:	8d 76 00             	lea    0x0(%esi),%esi
80103948:	83 c2 01             	add    $0x1,%edx
8010394b:	39 f2                	cmp    %esi,%edx
8010394d:	74 1e                	je     8010396d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010394f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103955:	0f b6 81 a0 37 11 80 	movzbl -0x7feec860(%ecx),%eax
8010395c:	39 d8                	cmp    %ebx,%eax
8010395e:	75 e8                	jne    80103948 <mycpu+0x28>
}
80103960:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103963:	8d 81 a0 37 11 80    	lea    -0x7feec860(%ecx),%eax
}
80103969:	5b                   	pop    %ebx
8010396a:	5e                   	pop    %esi
8010396b:	5d                   	pop    %ebp
8010396c:	c3                   	ret    
  panic("unknown apicid\n");
8010396d:	83 ec 0c             	sub    $0xc,%esp
80103970:	68 4e 7c 10 80       	push   $0x80107c4e
80103975:	e8 16 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	68 2c 7d 10 80       	push   $0x80107d2c
80103982:	e8 09 ca ff ff       	call   80100390 <panic>
80103987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010398e:	66 90                	xchg   %ax,%ax

80103990 <cpuid>:
cpuid() {
80103990:	f3 0f 1e fb          	endbr32 
80103994:	55                   	push   %ebp
80103995:	89 e5                	mov    %esp,%ebp
80103997:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010399a:	e8 81 ff ff ff       	call   80103920 <mycpu>
}
8010399f:	c9                   	leave  
  return mycpu()-cpus;
801039a0:	2d a0 37 11 80       	sub    $0x801137a0,%eax
801039a5:	c1 f8 04             	sar    $0x4,%eax
801039a8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ae:	c3                   	ret    
801039af:	90                   	nop

801039b0 <myproc>:
myproc(void) {
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	53                   	push   %ebx
801039b8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039bb:	e8 20 10 00 00       	call   801049e0 <pushcli>
  c = mycpu();
801039c0:	e8 5b ff ff ff       	call   80103920 <mycpu>
  p = c->proc;
801039c5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039cb:	e8 60 10 00 00       	call   80104a30 <popcli>
}
801039d0:	83 c4 04             	add    $0x4,%esp
801039d3:	89 d8                	mov    %ebx,%eax
801039d5:	5b                   	pop    %ebx
801039d6:	5d                   	pop    %ebp
801039d7:	c3                   	ret    
801039d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039df:	90                   	nop

801039e0 <userinit>:
{
801039e0:	f3 0f 1e fb          	endbr32 
801039e4:	55                   	push   %ebp
801039e5:	89 e5                	mov    %esp,%ebp
801039e7:	53                   	push   %ebx
801039e8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039eb:	e8 c0 fd ff ff       	call   801037b0 <allocproc>
801039f0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039f2:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801039f7:	e8 64 3a 00 00       	call   80107460 <setupkvm>
801039fc:	89 43 04             	mov    %eax,0x4(%ebx)
801039ff:	85 c0                	test   %eax,%eax
80103a01:	0f 84 c7 00 00 00    	je     80103ace <userinit+0xee>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a07:	83 ec 04             	sub    $0x4,%esp
80103a0a:	68 2c 00 00 00       	push   $0x2c
80103a0f:	68 60 b4 10 80       	push   $0x8010b460
80103a14:	50                   	push   %eax
80103a15:	e8 16 37 00 00       	call   80107130 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a1a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a1d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  p->threads = 1; // the main thread of process
80103a23:	c7 83 84 00 00 00 01 	movl   $0x1,0x84(%ebx)
80103a2a:	00 00 00 
  memset(p->tf, 0, sizeof(*p->tf));
80103a2d:	6a 4c                	push   $0x4c
80103a2f:	6a 00                	push   $0x0
80103a31:	ff 73 18             	pushl  0x18(%ebx)
80103a34:	e8 b7 11 00 00       	call   80104bf0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a39:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3c:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a41:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a44:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a49:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a4d:	8b 43 18             	mov    0x18(%ebx),%eax
80103a50:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a54:	8b 43 18             	mov    0x18(%ebx),%eax
80103a57:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a5b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a62:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a66:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a6a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a6d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a74:	8b 43 18             	mov    0x18(%ebx),%eax
80103a77:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a7e:	8b 43 18             	mov    0x18(%ebx),%eax
80103a81:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a88:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a8b:	6a 10                	push   $0x10
80103a8d:	68 77 7c 10 80       	push   $0x80107c77
80103a92:	50                   	push   %eax
80103a93:	e8 18 13 00 00       	call   80104db0 <safestrcpy>
  p->cwd = namei("/");
80103a98:	c7 04 24 80 7c 10 80 	movl   $0x80107c80,(%esp)
80103a9f:	e8 ac e5 ff ff       	call   80102050 <namei>
80103aa4:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103aa7:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80103aae:	e8 2d 10 00 00       	call   80104ae0 <acquire>
  p->state = RUNNABLE;
80103ab3:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103aba:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80103ac1:	e8 da 10 00 00       	call   80104ba0 <release>
}
80103ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ac9:	83 c4 10             	add    $0x10,%esp
80103acc:	c9                   	leave  
80103acd:	c3                   	ret    
    panic("userinit: out of memory?");
80103ace:	83 ec 0c             	sub    $0xc,%esp
80103ad1:	68 5e 7c 10 80       	push   $0x80107c5e
80103ad6:	e8 b5 c8 ff ff       	call   80100390 <panic>
80103adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103adf:	90                   	nop

80103ae0 <growproc>:
{
80103ae0:	f3 0f 1e fb          	endbr32 
80103ae4:	55                   	push   %ebp
80103ae5:	89 e5                	mov    %esp,%ebp
80103ae7:	56                   	push   %esi
80103ae8:	53                   	push   %ebx
80103ae9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103aec:	e8 ef 0e 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80103af1:	e8 2a fe ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103af6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103afc:	e8 2f 0f 00 00       	call   80104a30 <popcli>
  acquire(&thread);
80103b01:	83 ec 0c             	sub    $0xc,%esp
80103b04:	68 40 3d 11 80       	push   $0x80113d40
80103b09:	e8 d2 0f 00 00       	call   80104ae0 <acquire>
  sz = curproc->sz;
80103b0e:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b10:	83 c4 10             	add    $0x10,%esp
80103b13:	85 f6                	test   %esi,%esi
80103b15:	0f 8f a5 00 00 00    	jg     80103bc0 <growproc+0xe0>
  } else if(n < 0){
80103b1b:	0f 85 22 01 00 00    	jne    80103c43 <growproc+0x163>
  acquire(&ptable.lock);
80103b21:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b24:	89 03                	mov    %eax,(%ebx)
  acquire(&ptable.lock);
80103b26:	68 80 3d 11 80       	push   $0x80113d80
80103b2b:	e8 b0 0f 00 00       	call   80104ae0 <acquire>
  if (curproc->threads == -1){
80103b30:	83 c4 10             	add    $0x10,%esp
80103b33:	83 bb 84 00 00 00 ff 	cmpl   $0xffffffff,0x84(%ebx)
80103b3a:	0f 84 b8 00 00 00    	je     80103bf8 <growproc+0x118>
    numberOfChildren = curproc->parent->threads - 1;
80103b40:	8b 53 14             	mov    0x14(%ebx),%edx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b43:	b8 b4 3d 11 80       	mov    $0x80113db4,%eax
    if(numberOfChildren <= 0){
80103b48:	83 ba 84 00 00 00 01 	cmpl   $0x1,0x84(%edx)
80103b4f:	7f 13                	jg     80103b64 <growproc+0x84>
80103b51:	eb 3d                	jmp    80103b90 <growproc+0xb0>
80103b53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b57:	90                   	nop
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b58:	05 88 00 00 00       	add    $0x88,%eax
80103b5d:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80103b62:	74 2c                	je     80103b90 <growproc+0xb0>
        if(p->parent == curproc && p->threads == -1){
80103b64:	39 58 14             	cmp    %ebx,0x14(%eax)
80103b67:	75 ef                	jne    80103b58 <growproc+0x78>
80103b69:	83 b8 84 00 00 00 ff 	cmpl   $0xffffffff,0x84(%eax)
80103b70:	75 e6                	jne    80103b58 <growproc+0x78>
          p->sz = curproc->sz;
80103b72:	8b 13                	mov    (%ebx),%edx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b74:	05 88 00 00 00       	add    $0x88,%eax
          p->sz = curproc->sz;
80103b79:	89 90 78 ff ff ff    	mov    %edx,-0x88(%eax)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b7f:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80103b84:	75 de                	jne    80103b64 <growproc+0x84>
80103b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b8d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103b90:	83 ec 0c             	sub    $0xc,%esp
80103b93:	68 80 3d 11 80       	push   $0x80113d80
80103b98:	e8 03 10 00 00       	call   80104ba0 <release>
  release(&thread);
80103b9d:	c7 04 24 40 3d 11 80 	movl   $0x80113d40,(%esp)
80103ba4:	e8 f7 0f 00 00       	call   80104ba0 <release>
  switchuvm(curproc);
80103ba9:	89 1c 24             	mov    %ebx,(%esp)
80103bac:	e8 6f 34 00 00       	call   80107020 <switchuvm>
  return 0;
80103bb1:	83 c4 10             	add    $0x10,%esp
80103bb4:	31 c0                	xor    %eax,%eax
}
80103bb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bb9:	5b                   	pop    %ebx
80103bba:	5e                   	pop    %esi
80103bbb:	5d                   	pop    %ebp
80103bbc:	c3                   	ret    
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0){
80103bc0:	83 ec 04             	sub    $0x4,%esp
80103bc3:	01 c6                	add    %eax,%esi
80103bc5:	56                   	push   %esi
80103bc6:	50                   	push   %eax
80103bc7:	ff 73 04             	pushl  0x4(%ebx)
80103bca:	e8 b1 36 00 00       	call   80107280 <allocuvm>
80103bcf:	83 c4 10             	add    $0x10,%esp
80103bd2:	85 c0                	test   %eax,%eax
80103bd4:	0f 85 47 ff ff ff    	jne    80103b21 <growproc+0x41>
      release(&thread);
80103bda:	83 ec 0c             	sub    $0xc,%esp
80103bdd:	68 40 3d 11 80       	push   $0x80113d40
80103be2:	e8 b9 0f 00 00       	call   80104ba0 <release>
      return -1;
80103be7:	83 c4 10             	add    $0x10,%esp
80103bea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bef:	eb c5                	jmp    80103bb6 <growproc+0xd6>
80103bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    curproc->parent->sz = curproc->sz; // updating sz of parent to child sz
80103bf8:	8b 43 14             	mov    0x14(%ebx),%eax
80103bfb:	8b 13                	mov    (%ebx),%edx
80103bfd:	89 10                	mov    %edx,(%eax)
    numberOfChildren = curproc->parent->threads - 2;
80103bff:	8b 53 14             	mov    0x14(%ebx),%edx
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c02:	b8 b4 3d 11 80       	mov    $0x80113db4,%eax
    if(numberOfChildren <= 0){
80103c07:	83 ba 84 00 00 00 02 	cmpl   $0x2,0x84(%edx)
80103c0e:	7f 18                	jg     80103c28 <growproc+0x148>
80103c10:	e9 7b ff ff ff       	jmp    80103b90 <growproc+0xb0>
80103c15:	8d 76 00             	lea    0x0(%esi),%esi
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c18:	05 88 00 00 00       	add    $0x88,%eax
80103c1d:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80103c22:	0f 84 68 ff ff ff    	je     80103b90 <growproc+0xb0>
        if(p!= curproc && p->parent == curproc->parent && p->threads == -1){
80103c28:	39 c3                	cmp    %eax,%ebx
80103c2a:	74 ec                	je     80103c18 <growproc+0x138>
80103c2c:	8b 4b 14             	mov    0x14(%ebx),%ecx
80103c2f:	39 48 14             	cmp    %ecx,0x14(%eax)
80103c32:	75 e4                	jne    80103c18 <growproc+0x138>
80103c34:	83 b8 84 00 00 00 ff 	cmpl   $0xffffffff,0x84(%eax)
80103c3b:	75 db                	jne    80103c18 <growproc+0x138>
          p->sz = curproc->sz;
80103c3d:	8b 13                	mov    (%ebx),%edx
80103c3f:	89 10                	mov    %edx,(%eax)
          numberOfChildren--;
80103c41:	eb d5                	jmp    80103c18 <growproc+0x138>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0){
80103c43:	83 ec 04             	sub    $0x4,%esp
80103c46:	01 c6                	add    %eax,%esi
80103c48:	56                   	push   %esi
80103c49:	50                   	push   %eax
80103c4a:	ff 73 04             	pushl  0x4(%ebx)
80103c4d:	e8 5e 37 00 00       	call   801073b0 <deallocuvm>
80103c52:	83 c4 10             	add    $0x10,%esp
80103c55:	85 c0                	test   %eax,%eax
80103c57:	0f 85 c4 fe ff ff    	jne    80103b21 <growproc+0x41>
80103c5d:	e9 78 ff ff ff       	jmp    80103bda <growproc+0xfa>
80103c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c70 <fork>:
{
80103c70:	f3 0f 1e fb          	endbr32 
80103c74:	55                   	push   %ebp
80103c75:	89 e5                	mov    %esp,%ebp
80103c77:	57                   	push   %edi
80103c78:	56                   	push   %esi
80103c79:	53                   	push   %ebx
80103c7a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c7d:	e8 5e 0d 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80103c82:	e8 99 fc ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103c87:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c8d:	e8 9e 0d 00 00       	call   80104a30 <popcli>
  if((np = allocproc()) == 0){
80103c92:	e8 19 fb ff ff       	call   801037b0 <allocproc>
80103c97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c9a:	85 c0                	test   %eax,%eax
80103c9c:	0f 84 d3 00 00 00    	je     80103d75 <fork+0x105>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103ca2:	83 ec 08             	sub    $0x8,%esp
80103ca5:	ff 33                	pushl  (%ebx)
80103ca7:	89 c7                	mov    %eax,%edi
80103ca9:	ff 73 04             	pushl  0x4(%ebx)
80103cac:	e8 7f 38 00 00       	call   80107530 <copyuvm>
80103cb1:	83 c4 10             	add    $0x10,%esp
80103cb4:	89 47 04             	mov    %eax,0x4(%edi)
80103cb7:	85 c0                	test   %eax,%eax
80103cb9:	0f 84 bd 00 00 00    	je     80103d7c <fork+0x10c>
  np->sz = curproc->sz;
80103cbf:	8b 03                	mov    (%ebx),%eax
80103cc1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cc4:	89 01                	mov    %eax,(%ecx)
  np->stackTop = curproc->stackTop; // child and parent stack top must be same
80103cc6:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  *np->tf = *curproc->tf;
80103ccc:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ccf:	89 59 14             	mov    %ebx,0x14(%ecx)
  np->stackTop = curproc->stackTop; // child and parent stack top must be same
80103cd2:	89 81 80 00 00 00    	mov    %eax,0x80(%ecx)
  np->threads = 1; // child has only one thread
80103cd8:	89 c8                	mov    %ecx,%eax
80103cda:	c7 81 84 00 00 00 01 	movl   $0x1,0x84(%ecx)
80103ce1:	00 00 00 
  *np->tf = *curproc->tf;
80103ce4:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ce9:	8b 73 18             	mov    0x18(%ebx),%esi
80103cec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cee:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cf0:	8b 40 18             	mov    0x18(%eax),%eax
80103cf3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103d00:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d04:	85 c0                	test   %eax,%eax
80103d06:	74 13                	je     80103d1b <fork+0xab>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d08:	83 ec 0c             	sub    $0xc,%esp
80103d0b:	50                   	push   %eax
80103d0c:	e8 7f d1 ff ff       	call   80100e90 <filedup>
80103d11:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d1b:	83 c6 01             	add    $0x1,%esi
80103d1e:	83 fe 10             	cmp    $0x10,%esi
80103d21:	75 dd                	jne    80103d00 <fork+0x90>
  np->cwd = idup(curproc->cwd);
80103d23:	83 ec 0c             	sub    $0xc,%esp
80103d26:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d29:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d2c:	e8 1f da ff ff       	call   80101750 <idup>
80103d31:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d34:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d37:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d3a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d3d:	6a 10                	push   $0x10
80103d3f:	53                   	push   %ebx
80103d40:	50                   	push   %eax
80103d41:	e8 6a 10 00 00       	call   80104db0 <safestrcpy>
  pid = np->pid;
80103d46:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d49:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80103d50:	e8 8b 0d 00 00       	call   80104ae0 <acquire>
  np->state = RUNNABLE;
80103d55:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d5c:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80103d63:	e8 38 0e 00 00       	call   80104ba0 <release>
  return pid;
80103d68:	83 c4 10             	add    $0x10,%esp
}
80103d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d6e:	89 d8                	mov    %ebx,%eax
80103d70:	5b                   	pop    %ebx
80103d71:	5e                   	pop    %esi
80103d72:	5f                   	pop    %edi
80103d73:	5d                   	pop    %ebp
80103d74:	c3                   	ret    
    return -1;
80103d75:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d7a:	eb ef                	jmp    80103d6b <fork+0xfb>
    kfree(np->kstack);
80103d7c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d7f:	83 ec 0c             	sub    $0xc,%esp
80103d82:	ff 73 08             	pushl  0x8(%ebx)
80103d85:	e8 06 e7 ff ff       	call   80102490 <kfree>
    np->kstack = 0;
80103d8a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d91:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d94:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103da0:	eb c9                	jmp    80103d6b <fork+0xfb>
80103da2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103db0 <check_pgdir_share>:
check_pgdir_share(struct proc *process){
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	55                   	push   %ebp
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
80103db5:	b8 b4 3d 11 80       	mov    $0x80113db4,%eax
check_pgdir_share(struct proc *process){
80103dba:	89 e5                	mov    %esp,%ebp
80103dbc:	8b 55 08             	mov    0x8(%ebp),%edx
80103dbf:	eb 13                	jmp    80103dd4 <check_pgdir_share+0x24>
80103dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
80103dc8:	05 88 00 00 00       	add    $0x88,%eax
80103dcd:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80103dd2:	74 14                	je     80103de8 <check_pgdir_share+0x38>
    if(p != process && p->pgdir == process->pgdir){
80103dd4:	39 c2                	cmp    %eax,%edx
80103dd6:	74 f0                	je     80103dc8 <check_pgdir_share+0x18>
80103dd8:	8b 4a 04             	mov    0x4(%edx),%ecx
80103ddb:	39 48 04             	cmp    %ecx,0x4(%eax)
80103dde:	75 e8                	jne    80103dc8 <check_pgdir_share+0x18>
      return 0;
80103de0:	31 c0                	xor    %eax,%eax
}
80103de2:	5d                   	pop    %ebp
80103de3:	c3                   	ret    
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 1;
80103de8:	b8 01 00 00 00       	mov    $0x1,%eax
}
80103ded:	5d                   	pop    %ebp
80103dee:	c3                   	ret    
80103def:	90                   	nop

80103df0 <scheduler>:
{
80103df0:	f3 0f 1e fb          	endbr32 
80103df4:	55                   	push   %ebp
80103df5:	89 e5                	mov    %esp,%ebp
80103df7:	57                   	push   %edi
80103df8:	56                   	push   %esi
80103df9:	53                   	push   %ebx
80103dfa:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103dfd:	e8 1e fb ff ff       	call   80103920 <mycpu>
  c->proc = 0;
80103e02:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e09:	00 00 00 
  struct cpu *c = mycpu();
80103e0c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e0e:	8d 78 04             	lea    0x4(%eax),%edi
80103e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103e18:	fb                   	sti    
    acquire(&ptable.lock);
80103e19:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e1c:	bb b4 3d 11 80       	mov    $0x80113db4,%ebx
    acquire(&ptable.lock);
80103e21:	68 80 3d 11 80       	push   $0x80113d80
80103e26:	e8 b5 0c 00 00       	call   80104ae0 <acquire>
80103e2b:	83 c4 10             	add    $0x10,%esp
80103e2e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103e30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e34:	75 33                	jne    80103e69 <scheduler+0x79>
      switchuvm(p);
80103e36:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e39:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e3f:	53                   	push   %ebx
80103e40:	e8 db 31 00 00       	call   80107020 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e45:	58                   	pop    %eax
80103e46:	5a                   	pop    %edx
80103e47:	ff 73 1c             	pushl  0x1c(%ebx)
80103e4a:	57                   	push   %edi
      p->state = RUNNING;
80103e4b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e52:	e8 bc 0f 00 00       	call   80104e13 <swtch>
      switchkvm();
80103e57:	e8 a4 31 00 00       	call   80107000 <switchkvm>
      c->proc = 0;
80103e5c:	83 c4 10             	add    $0x10,%esp
80103e5f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e66:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e69:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103e6f:	81 fb b4 5f 11 80    	cmp    $0x80115fb4,%ebx
80103e75:	75 b9                	jne    80103e30 <scheduler+0x40>
    release(&ptable.lock);
80103e77:	83 ec 0c             	sub    $0xc,%esp
80103e7a:	68 80 3d 11 80       	push   $0x80113d80
80103e7f:	e8 1c 0d 00 00       	call   80104ba0 <release>
    sti();
80103e84:	83 c4 10             	add    $0x10,%esp
80103e87:	eb 8f                	jmp    80103e18 <scheduler+0x28>
80103e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e90 <sched>:
{
80103e90:	f3 0f 1e fb          	endbr32 
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	56                   	push   %esi
80103e98:	53                   	push   %ebx
  pushcli();
80103e99:	e8 42 0b 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80103e9e:	e8 7d fa ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103ea3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ea9:	e8 82 0b 00 00       	call   80104a30 <popcli>
  if(!holding(&ptable.lock))
80103eae:	83 ec 0c             	sub    $0xc,%esp
80103eb1:	68 80 3d 11 80       	push   $0x80113d80
80103eb6:	e8 d5 0b 00 00       	call   80104a90 <holding>
80103ebb:	83 c4 10             	add    $0x10,%esp
80103ebe:	85 c0                	test   %eax,%eax
80103ec0:	74 4f                	je     80103f11 <sched+0x81>
  if(mycpu()->ncli != 1)
80103ec2:	e8 59 fa ff ff       	call   80103920 <mycpu>
80103ec7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103ece:	75 68                	jne    80103f38 <sched+0xa8>
  if(p->state == RUNNING)
80103ed0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ed4:	74 55                	je     80103f2b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ed6:	9c                   	pushf  
80103ed7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ed8:	f6 c4 02             	test   $0x2,%ah
80103edb:	75 41                	jne    80103f1e <sched+0x8e>
  intena = mycpu()->intena;
80103edd:	e8 3e fa ff ff       	call   80103920 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ee2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ee5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103eeb:	e8 30 fa ff ff       	call   80103920 <mycpu>
80103ef0:	83 ec 08             	sub    $0x8,%esp
80103ef3:	ff 70 04             	pushl  0x4(%eax)
80103ef6:	53                   	push   %ebx
80103ef7:	e8 17 0f 00 00       	call   80104e13 <swtch>
  mycpu()->intena = intena;
80103efc:	e8 1f fa ff ff       	call   80103920 <mycpu>
}
80103f01:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f04:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f0a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f0d:	5b                   	pop    %ebx
80103f0e:	5e                   	pop    %esi
80103f0f:	5d                   	pop    %ebp
80103f10:	c3                   	ret    
    panic("sched ptable.lock");
80103f11:	83 ec 0c             	sub    $0xc,%esp
80103f14:	68 82 7c 10 80       	push   $0x80107c82
80103f19:	e8 72 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f1e:	83 ec 0c             	sub    $0xc,%esp
80103f21:	68 ae 7c 10 80       	push   $0x80107cae
80103f26:	e8 65 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f2b:	83 ec 0c             	sub    $0xc,%esp
80103f2e:	68 a0 7c 10 80       	push   $0x80107ca0
80103f33:	e8 58 c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f38:	83 ec 0c             	sub    $0xc,%esp
80103f3b:	68 94 7c 10 80       	push   $0x80107c94
80103f40:	e8 4b c4 ff ff       	call   80100390 <panic>
80103f45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f50 <exit>:
{
80103f50:	f3 0f 1e fb          	endbr32 
80103f54:	55                   	push   %ebp
80103f55:	89 e5                	mov    %esp,%ebp
80103f57:	57                   	push   %edi
80103f58:	56                   	push   %esi
80103f59:	53                   	push   %ebx
80103f5a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f5d:	e8 7e 0a 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80103f62:	e8 b9 f9 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80103f67:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f6d:	e8 be 0a 00 00       	call   80104a30 <popcli>
  if(curproc == initproc)
80103f72:	8d 73 28             	lea    0x28(%ebx),%esi
80103f75:	8d 7b 68             	lea    0x68(%ebx),%edi
80103f78:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80103f7e:	0f 84 0d 01 00 00    	je     80104091 <exit+0x141>
80103f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103f88:	8b 06                	mov    (%esi),%eax
80103f8a:	85 c0                	test   %eax,%eax
80103f8c:	74 12                	je     80103fa0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103f8e:	83 ec 0c             	sub    $0xc,%esp
80103f91:	50                   	push   %eax
80103f92:	e8 49 cf ff ff       	call   80100ee0 <fileclose>
      curproc->ofile[fd] = 0;
80103f97:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f9d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103fa0:	83 c6 04             	add    $0x4,%esi
80103fa3:	39 f7                	cmp    %esi,%edi
80103fa5:	75 e1                	jne    80103f88 <exit+0x38>
  begin_op();
80103fa7:	e8 a4 ed ff ff       	call   80102d50 <begin_op>
  iput(curproc->cwd);
80103fac:	83 ec 0c             	sub    $0xc,%esp
80103faf:	ff 73 68             	pushl  0x68(%ebx)
80103fb2:	e8 f9 d8 ff ff       	call   801018b0 <iput>
  end_op();
80103fb7:	e8 04 ee ff ff       	call   80102dc0 <end_op>
  curproc->cwd = 0;
80103fbc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103fc3:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
80103fca:	e8 11 0b 00 00       	call   80104ae0 <acquire>
  if(curproc->threads == -1){
80103fcf:	83 c4 10             	add    $0x10,%esp
80103fd2:	83 bb 84 00 00 00 ff 	cmpl   $0xffffffff,0x84(%ebx)
80103fd9:	75 0a                	jne    80103fe5 <exit+0x95>
    curproc->parent->threads -= 1;
80103fdb:	8b 43 14             	mov    0x14(%ebx),%eax
80103fde:	83 a8 84 00 00 00 01 	subl   $0x1,0x84(%eax)
  wakeup1(curproc->parent);
80103fe5:	8b 53 14             	mov    0x14(%ebx),%edx
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fe8:	b8 b4 3d 11 80       	mov    $0x80113db4,%eax
80103fed:	eb 0d                	jmp    80103ffc <exit+0xac>
80103fef:	90                   	nop
80103ff0:	05 88 00 00 00       	add    $0x88,%eax
80103ff5:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80103ffa:	74 1e                	je     8010401a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
80103ffc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104000:	75 ee                	jne    80103ff0 <exit+0xa0>
80104002:	3b 50 20             	cmp    0x20(%eax),%edx
80104005:	75 e9                	jne    80103ff0 <exit+0xa0>
      p->state = RUNNABLE;
80104007:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010400e:	05 88 00 00 00       	add    $0x88,%eax
80104013:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80104018:	75 e2                	jne    80103ffc <exit+0xac>
      p->parent = initproc;
8010401a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104020:	ba b4 3d 11 80       	mov    $0x80113db4,%edx
80104025:	eb 17                	jmp    8010403e <exit+0xee>
80104027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010402e:	66 90                	xchg   %ax,%ax
80104030:	81 c2 88 00 00 00    	add    $0x88,%edx
80104036:	81 fa b4 5f 11 80    	cmp    $0x80115fb4,%edx
8010403c:	74 3a                	je     80104078 <exit+0x128>
    if(p->parent == curproc){
8010403e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104041:	75 ed                	jne    80104030 <exit+0xe0>
      if(p->state == ZOMBIE)
80104043:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104047:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010404a:	75 e4                	jne    80104030 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010404c:	b8 b4 3d 11 80       	mov    $0x80113db4,%eax
80104051:	eb 11                	jmp    80104064 <exit+0x114>
80104053:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104057:	90                   	nop
80104058:	05 88 00 00 00       	add    $0x88,%eax
8010405d:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80104062:	74 cc                	je     80104030 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
80104064:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104068:	75 ee                	jne    80104058 <exit+0x108>
8010406a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010406d:	75 e9                	jne    80104058 <exit+0x108>
      p->state = RUNNABLE;
8010406f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104076:	eb e0                	jmp    80104058 <exit+0x108>
  curproc->state = ZOMBIE;
80104078:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010407f:	e8 0c fe ff ff       	call   80103e90 <sched>
  panic("zombie exit");
80104084:	83 ec 0c             	sub    $0xc,%esp
80104087:	68 cf 7c 10 80       	push   $0x80107ccf
8010408c:	e8 ff c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104091:	83 ec 0c             	sub    $0xc,%esp
80104094:	68 c2 7c 10 80       	push   $0x80107cc2
80104099:	e8 f2 c2 ff ff       	call   80100390 <panic>
8010409e:	66 90                	xchg   %ax,%ax

801040a0 <yield>:
{
801040a0:	f3 0f 1e fb          	endbr32 
801040a4:	55                   	push   %ebp
801040a5:	89 e5                	mov    %esp,%ebp
801040a7:	53                   	push   %ebx
801040a8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040ab:	68 80 3d 11 80       	push   $0x80113d80
801040b0:	e8 2b 0a 00 00       	call   80104ae0 <acquire>
  pushcli();
801040b5:	e8 26 09 00 00       	call   801049e0 <pushcli>
  c = mycpu();
801040ba:	e8 61 f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
801040bf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040c5:	e8 66 09 00 00       	call   80104a30 <popcli>
  myproc()->state = RUNNABLE;
801040ca:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040d1:	e8 ba fd ff ff       	call   80103e90 <sched>
  release(&ptable.lock);
801040d6:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
801040dd:	e8 be 0a 00 00       	call   80104ba0 <release>
}
801040e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e5:	83 c4 10             	add    $0x10,%esp
801040e8:	c9                   	leave  
801040e9:	c3                   	ret    
801040ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040f0 <sleep>:
{
801040f0:	f3 0f 1e fb          	endbr32 
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	57                   	push   %edi
801040f8:	56                   	push   %esi
801040f9:	53                   	push   %ebx
801040fa:	83 ec 0c             	sub    $0xc,%esp
801040fd:	8b 7d 08             	mov    0x8(%ebp),%edi
80104100:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104103:	e8 d8 08 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80104108:	e8 13 f8 ff ff       	call   80103920 <mycpu>
  p = c->proc;
8010410d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104113:	e8 18 09 00 00       	call   80104a30 <popcli>
  if(p == 0)
80104118:	85 db                	test   %ebx,%ebx
8010411a:	0f 84 83 00 00 00    	je     801041a3 <sleep+0xb3>
  if(lk == 0)
80104120:	85 f6                	test   %esi,%esi
80104122:	74 72                	je     80104196 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104124:	81 fe 80 3d 11 80    	cmp    $0x80113d80,%esi
8010412a:	74 4c                	je     80104178 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010412c:	83 ec 0c             	sub    $0xc,%esp
8010412f:	68 80 3d 11 80       	push   $0x80113d80
80104134:	e8 a7 09 00 00       	call   80104ae0 <acquire>
    release(lk);
80104139:	89 34 24             	mov    %esi,(%esp)
8010413c:	e8 5f 0a 00 00       	call   80104ba0 <release>
  p->chan = chan;
80104141:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104144:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010414b:	e8 40 fd ff ff       	call   80103e90 <sched>
  p->chan = 0;
80104150:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104157:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
8010415e:	e8 3d 0a 00 00       	call   80104ba0 <release>
    acquire(lk);
80104163:	89 75 08             	mov    %esi,0x8(%ebp)
80104166:	83 c4 10             	add    $0x10,%esp
}
80104169:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010416c:	5b                   	pop    %ebx
8010416d:	5e                   	pop    %esi
8010416e:	5f                   	pop    %edi
8010416f:	5d                   	pop    %ebp
    acquire(lk);
80104170:	e9 6b 09 00 00       	jmp    80104ae0 <acquire>
80104175:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104178:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010417b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104182:	e8 09 fd ff ff       	call   80103e90 <sched>
  p->chan = 0;
80104187:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010418e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104191:	5b                   	pop    %ebx
80104192:	5e                   	pop    %esi
80104193:	5f                   	pop    %edi
80104194:	5d                   	pop    %ebp
80104195:	c3                   	ret    
    panic("sleep without lk");
80104196:	83 ec 0c             	sub    $0xc,%esp
80104199:	68 e1 7c 10 80       	push   $0x80107ce1
8010419e:	e8 ed c1 ff ff       	call   80100390 <panic>
    panic("sleep");
801041a3:	83 ec 0c             	sub    $0xc,%esp
801041a6:	68 db 7c 10 80       	push   $0x80107cdb
801041ab:	e8 e0 c1 ff ff       	call   80100390 <panic>

801041b0 <wait>:
{
801041b0:	f3 0f 1e fb          	endbr32 
801041b4:	55                   	push   %ebp
801041b5:	89 e5                	mov    %esp,%ebp
801041b7:	56                   	push   %esi
801041b8:	53                   	push   %ebx
  pushcli();
801041b9:	e8 22 08 00 00       	call   801049e0 <pushcli>
  c = mycpu();
801041be:	e8 5d f7 ff ff       	call   80103920 <mycpu>
  p = c->proc;
801041c3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041c9:	e8 62 08 00 00       	call   80104a30 <popcli>
  acquire(&ptable.lock);
801041ce:	83 ec 0c             	sub    $0xc,%esp
801041d1:	68 80 3d 11 80       	push   $0x80113d80
801041d6:	e8 05 09 00 00       	call   80104ae0 <acquire>
801041db:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041de:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041e0:	bb b4 3d 11 80       	mov    $0x80113db4,%ebx
801041e5:	eb 17                	jmp    801041fe <wait+0x4e>
801041e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041ee:	66 90                	xchg   %ax,%ax
801041f0:	81 c3 88 00 00 00    	add    $0x88,%ebx
801041f6:	81 fb b4 5f 11 80    	cmp    $0x80115fb4,%ebx
801041fc:	74 27                	je     80104225 <wait+0x75>
      if(p->parent != curproc)
801041fe:	39 73 14             	cmp    %esi,0x14(%ebx)
80104201:	75 ed                	jne    801041f0 <wait+0x40>
      if(p->threads == -1){
80104203:	83 bb 84 00 00 00 ff 	cmpl   $0xffffffff,0x84(%ebx)
8010420a:	74 06                	je     80104212 <wait+0x62>
      if(p->state == ZOMBIE){
8010420c:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104210:	74 3e                	je     80104250 <wait+0xa0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104212:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
80104218:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010421d:	81 fb b4 5f 11 80    	cmp    $0x80115fb4,%ebx
80104223:	75 d9                	jne    801041fe <wait+0x4e>
    if(!havekids || curproc->killed){
80104225:	85 c0                	test   %eax,%eax
80104227:	0f 84 c2 00 00 00    	je     801042ef <wait+0x13f>
8010422d:	8b 46 24             	mov    0x24(%esi),%eax
80104230:	85 c0                	test   %eax,%eax
80104232:	0f 85 b7 00 00 00    	jne    801042ef <wait+0x13f>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104238:	83 ec 08             	sub    $0x8,%esp
8010423b:	68 80 3d 11 80       	push   $0x80113d80
80104240:	56                   	push   %esi
80104241:	e8 aa fe ff ff       	call   801040f0 <sleep>
    havekids = 0;
80104246:	83 c4 10             	add    $0x10,%esp
80104249:	eb 93                	jmp    801041de <wait+0x2e>
8010424b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010424f:	90                   	nop
        kfree(p->kstack);
80104250:	83 ec 0c             	sub    $0xc,%esp
80104253:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104256:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104259:	e8 32 e2 ff ff       	call   80102490 <kfree>
        p->kstack = 0;
8010425e:	8b 53 04             	mov    0x4(%ebx),%edx
80104261:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
80104264:	b8 b4 3d 11 80       	mov    $0x80113db4,%eax
        p->kstack = 0;
80104269:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
80104270:	eb 12                	jmp    80104284 <wait+0xd4>
80104272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104278:	05 88 00 00 00       	add    $0x88,%eax
8010427d:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80104282:	74 5d                	je     801042e1 <wait+0x131>
    if(p != process && p->pgdir == process->pgdir){
80104284:	39 c3                	cmp    %eax,%ebx
80104286:	74 f0                	je     80104278 <wait+0xc8>
80104288:	39 50 04             	cmp    %edx,0x4(%eax)
8010428b:	75 eb                	jne    80104278 <wait+0xc8>
        release(&ptable.lock);
8010428d:	83 ec 0c             	sub    $0xc,%esp
        p->pid = 0;
80104290:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
80104297:	68 80 3d 11 80       	push   $0x80113d80
        p->parent = 0;
8010429c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042a3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042a7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042ae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->stackTop = -1;
801042b5:	c7 83 80 00 00 00 ff 	movl   $0xffffffff,0x80(%ebx)
801042bc:	ff ff ff 
        p->pgdir = 0;
801042bf:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        p->threads = -1;
801042c6:	c7 83 84 00 00 00 ff 	movl   $0xffffffff,0x84(%ebx)
801042cd:	ff ff ff 
        release(&ptable.lock);
801042d0:	e8 cb 08 00 00       	call   80104ba0 <release>
        return pid;
801042d5:	83 c4 10             	add    $0x10,%esp
}
801042d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042db:	89 f0                	mov    %esi,%eax
801042dd:	5b                   	pop    %ebx
801042de:	5e                   	pop    %esi
801042df:	5d                   	pop    %ebp
801042e0:	c3                   	ret    
          freevm(p->pgdir);
801042e1:	83 ec 0c             	sub    $0xc,%esp
801042e4:	52                   	push   %edx
801042e5:	e8 f6 30 00 00       	call   801073e0 <freevm>
801042ea:	83 c4 10             	add    $0x10,%esp
801042ed:	eb 9e                	jmp    8010428d <wait+0xdd>
      release(&ptable.lock);
801042ef:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042f2:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042f7:	68 80 3d 11 80       	push   $0x80113d80
801042fc:	e8 9f 08 00 00       	call   80104ba0 <release>
      return -1;
80104301:	83 c4 10             	add    $0x10,%esp
80104304:	eb d2                	jmp    801042d8 <wait+0x128>
80104306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010430d:	8d 76 00             	lea    0x0(%esi),%esi

80104310 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	53                   	push   %ebx
80104318:	83 ec 10             	sub    $0x10,%esp
8010431b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010431e:	68 80 3d 11 80       	push   $0x80113d80
80104323:	e8 b8 07 00 00       	call   80104ae0 <acquire>
80104328:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010432b:	b8 b4 3d 11 80       	mov    $0x80113db4,%eax
80104330:	eb 12                	jmp    80104344 <wakeup+0x34>
80104332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104338:	05 88 00 00 00       	add    $0x88,%eax
8010433d:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80104342:	74 1e                	je     80104362 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104344:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104348:	75 ee                	jne    80104338 <wakeup+0x28>
8010434a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010434d:	75 e9                	jne    80104338 <wakeup+0x28>
      p->state = RUNNABLE;
8010434f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104356:	05 88 00 00 00       	add    $0x88,%eax
8010435b:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80104360:	75 e2                	jne    80104344 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104362:	c7 45 08 80 3d 11 80 	movl   $0x80113d80,0x8(%ebp)
}
80104369:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010436c:	c9                   	leave  
  release(&ptable.lock);
8010436d:	e9 2e 08 00 00       	jmp    80104ba0 <release>
80104372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104380 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104380:	f3 0f 1e fb          	endbr32 
80104384:	55                   	push   %ebp
80104385:	89 e5                	mov    %esp,%ebp
80104387:	53                   	push   %ebx
80104388:	83 ec 10             	sub    $0x10,%esp
8010438b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010438e:	68 80 3d 11 80       	push   $0x80113d80
80104393:	e8 48 07 00 00       	call   80104ae0 <acquire>
80104398:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010439b:	b8 b4 3d 11 80       	mov    $0x80113db4,%eax
801043a0:	eb 12                	jmp    801043b4 <kill+0x34>
801043a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043a8:	05 88 00 00 00       	add    $0x88,%eax
801043ad:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
801043b2:	74 34                	je     801043e8 <kill+0x68>
    if(p->pid == pid){
801043b4:	39 58 10             	cmp    %ebx,0x10(%eax)
801043b7:	75 ef                	jne    801043a8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043b9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043bd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043c4:	75 07                	jne    801043cd <kill+0x4d>
        p->state = RUNNABLE;
801043c6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043cd:	83 ec 0c             	sub    $0xc,%esp
801043d0:	68 80 3d 11 80       	push   $0x80113d80
801043d5:	e8 c6 07 00 00       	call   80104ba0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043dd:	83 c4 10             	add    $0x10,%esp
801043e0:	31 c0                	xor    %eax,%eax
}
801043e2:	c9                   	leave  
801043e3:	c3                   	ret    
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	68 80 3d 11 80       	push   $0x80113d80
801043f0:	e8 ab 07 00 00       	call   80104ba0 <release>
}
801043f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043f8:	83 c4 10             	add    $0x10,%esp
801043fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104400:	c9                   	leave  
80104401:	c3                   	ret    
80104402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104410 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104410:	f3 0f 1e fb          	endbr32 
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	57                   	push   %edi
80104418:	56                   	push   %esi
80104419:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010441c:	53                   	push   %ebx
8010441d:	bb 20 3e 11 80       	mov    $0x80113e20,%ebx
80104422:	83 ec 3c             	sub    $0x3c,%esp
80104425:	eb 2b                	jmp    80104452 <procdump+0x42>
80104427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104430:	83 ec 0c             	sub    $0xc,%esp
80104433:	68 87 80 10 80       	push   $0x80108087
80104438:	e8 73 c2 ff ff       	call   801006b0 <cprintf>
8010443d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104440:	81 c3 88 00 00 00    	add    $0x88,%ebx
80104446:	81 fb 20 60 11 80    	cmp    $0x80116020,%ebx
8010444c:	0f 84 8e 00 00 00    	je     801044e0 <procdump+0xd0>
    if(p->state == UNUSED)
80104452:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104455:	85 c0                	test   %eax,%eax
80104457:	74 e7                	je     80104440 <procdump+0x30>
      state = "???";
80104459:	ba f2 7c 10 80       	mov    $0x80107cf2,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010445e:	83 f8 05             	cmp    $0x5,%eax
80104461:	77 11                	ja     80104474 <procdump+0x64>
80104463:	8b 14 85 54 7d 10 80 	mov    -0x7fef82ac(,%eax,4),%edx
      state = "???";
8010446a:	b8 f2 7c 10 80       	mov    $0x80107cf2,%eax
8010446f:	85 d2                	test   %edx,%edx
80104471:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104474:	53                   	push   %ebx
80104475:	52                   	push   %edx
80104476:	ff 73 a4             	pushl  -0x5c(%ebx)
80104479:	68 f6 7c 10 80       	push   $0x80107cf6
8010447e:	e8 2d c2 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104483:	83 c4 10             	add    $0x10,%esp
80104486:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010448a:	75 a4                	jne    80104430 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010448c:	83 ec 08             	sub    $0x8,%esp
8010448f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104492:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104495:	50                   	push   %eax
80104496:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104499:	8b 40 0c             	mov    0xc(%eax),%eax
8010449c:	83 c0 08             	add    $0x8,%eax
8010449f:	50                   	push   %eax
801044a0:	e8 db 04 00 00       	call   80104980 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044a5:	83 c4 10             	add    $0x10,%esp
801044a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044af:	90                   	nop
801044b0:	8b 17                	mov    (%edi),%edx
801044b2:	85 d2                	test   %edx,%edx
801044b4:	0f 84 76 ff ff ff    	je     80104430 <procdump+0x20>
        cprintf(" %p", pc[i]);
801044ba:	83 ec 08             	sub    $0x8,%esp
801044bd:	83 c7 04             	add    $0x4,%edi
801044c0:	52                   	push   %edx
801044c1:	68 41 77 10 80       	push   $0x80107741
801044c6:	e8 e5 c1 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044cb:	83 c4 10             	add    $0x10,%esp
801044ce:	39 fe                	cmp    %edi,%esi
801044d0:	75 de                	jne    801044b0 <procdump+0xa0>
801044d2:	e9 59 ff ff ff       	jmp    80104430 <procdump+0x20>
801044d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044de:	66 90                	xchg   %ax,%ax
  }
}
801044e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044e3:	5b                   	pop    %ebx
801044e4:	5e                   	pop    %esi
801044e5:	5f                   	pop    %edi
801044e6:	5d                   	pop    %ebp
801044e7:	c3                   	ret    
801044e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ef:	90                   	nop

801044f0 <getProcCount>:

int 
getProcCount(void)
{
801044f0:	f3 0f 1e fb          	endbr32 
801044f4:	55                   	push   %ebp
801044f5:	89 e5                	mov    %esp,%ebp
801044f7:	53                   	push   %ebx
  struct proc *p;

  acquire(&ptable.lock);
  int count = 0;
801044f8:	31 db                	xor    %ebx,%ebx
{
801044fa:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801044fd:	68 80 3d 11 80       	push   $0x80113d80
80104502:	e8 d9 05 00 00       	call   80104ae0 <acquire>
80104507:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010450a:	b8 b4 3d 11 80       	mov    $0x80113db4,%eax
8010450f:	90                   	nop
  {
    if (p->state != UNUSED)
    {
      count++;
80104510:	83 78 0c 01          	cmpl   $0x1,0xc(%eax)
80104514:	83 db ff             	sbb    $0xffffffff,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104517:	05 88 00 00 00       	add    $0x88,%eax
8010451c:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80104521:	75 ed                	jne    80104510 <getProcCount+0x20>
    }
  }
  release(&ptable.lock);
80104523:	83 ec 0c             	sub    $0xc,%esp
80104526:	68 80 3d 11 80       	push   $0x80113d80
8010452b:	e8 70 06 00 00       	call   80104ba0 <release>
  return count;
}
80104530:	89 d8                	mov    %ebx,%eax
80104532:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104535:	c9                   	leave  
80104536:	c3                   	ret    
80104537:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010453e:	66 90                	xchg   %ax,%ax

80104540 <clone>:


int
clone(void *stack)
{
80104540:	f3 0f 1e fb          	endbr32 
80104544:	55                   	push   %ebp
80104545:	89 e5                	mov    %esp,%ebp
80104547:	57                   	push   %edi
80104548:	56                   	push   %esi
80104549:	53                   	push   %ebx
8010454a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
8010454d:	e8 8e 04 00 00       	call   801049e0 <pushcli>
  c = mycpu();
80104552:	e8 c9 f3 ff ff       	call   80103920 <mycpu>
  p = c->proc;
80104557:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010455d:	e8 ce 04 00 00       	call   80104a30 <popcli>
  int pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80104562:	e8 49 f2 ff ff       	call   801037b0 <allocproc>
80104567:	85 c0                	test   %eax,%eax
80104569:	0f 84 44 01 00 00    	je     801046b3 <clone+0x173>
8010456f:	89 c2                	mov    %eax,%edx
    return -1;
  }

  curproc->threads += 1;
  np->stackTop = (int)((char*)stack+PGSIZE);
80104571:	8b 45 08             	mov    0x8(%ebp),%eax

  acquire(&ptable.lock);
80104574:	83 ec 0c             	sub    $0xc,%esp
  curproc->threads += 1;
80104577:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
  np->stackTop = (int)((char*)stack+PGSIZE);
8010457e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104581:	05 00 10 00 00       	add    $0x1000,%eax
80104586:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  acquire(&ptable.lock);
8010458c:	68 80 3d 11 80       	push   $0x80113d80
80104591:	e8 4a 05 00 00       	call   80104ae0 <acquire>
  np->pgdir = curproc->pgdir;
80104596:	8b 43 04             	mov    0x4(%ebx),%eax
80104599:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010459c:	89 42 04             	mov    %eax,0x4(%edx)
  np->sz = curproc->sz;
8010459f:	8b 03                	mov    (%ebx),%eax
801045a1:	89 02                	mov    %eax,(%edx)
  release(&ptable.lock);
801045a3:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
801045aa:	e8 f1 05 00 00       	call   80104ba0 <release>

  int byteOnStack = curproc->stackTop - curproc->tf->esp;
801045af:	8b 43 18             	mov    0x18(%ebx),%eax
  np->tf->esp = np->stackTop - byteOnStack;
801045b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  memmove((void*)np->tf->esp, (void*)curproc->tf->esp, byteOnStack);
801045b5:	83 c4 0c             	add    $0xc,%esp
  int byteOnStack = curproc->stackTop - curproc->tf->esp;
801045b8:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
  memmove((void*)np->tf->esp, (void*)curproc->tf->esp, byteOnStack);
801045be:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int byteOnStack = curproc->stackTop - curproc->tf->esp;
801045c1:	89 cf                	mov    %ecx,%edi
801045c3:	2b 78 44             	sub    0x44(%eax),%edi
  np->tf->esp = np->stackTop - byteOnStack;
801045c6:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
801045cc:	8b 4a 18             	mov    0x18(%edx),%ecx
  memmove((void*)np->tf->esp, (void*)curproc->tf->esp, byteOnStack);
801045cf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  np->tf->esp = np->stackTop - byteOnStack;
801045d2:	29 f8                	sub    %edi,%eax
801045d4:	89 41 44             	mov    %eax,0x44(%ecx)
  memmove((void*)np->tf->esp, (void*)curproc->tf->esp, byteOnStack);
801045d7:	57                   	push   %edi
801045d8:	8b 43 18             	mov    0x18(%ebx),%eax
801045db:	ff 70 44             	pushl  0x44(%eax)
801045de:	8b 42 18             	mov    0x18(%edx),%eax
801045e1:	ff 70 44             	pushl  0x44(%eax)
801045e4:	e8 a7 06 00 00       	call   80104c90 <memmove>

  np->parent = curproc;
801045e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  *np->tf = *curproc->tf;
801045ec:	b9 13 00 00 00       	mov    $0x13,%ecx

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  np->tf->esp = np->stackTop - byteOnStack;
  np->tf->ebp = np->stackTop - (curproc->stackTop - curproc->tf->ebp);
801045f1:	83 c4 10             	add    $0x10,%esp
  np->parent = curproc;
801045f4:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801045f7:	8b 7a 18             	mov    0x18(%edx),%edi
801045fa:	8b 73 18             	mov    0x18(%ebx),%esi
801045fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  int i;
  for(i = 0; i < NOFILE; i++)
801045ff:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
80104601:	8b 42 18             	mov    0x18(%edx),%eax
80104604:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  np->tf->esp = np->stackTop - byteOnStack;
8010460b:	8b 4a 18             	mov    0x18(%edx),%ecx
8010460e:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
80104614:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80104617:	89 41 44             	mov    %eax,0x44(%ecx)
  np->tf->ebp = np->stackTop - (curproc->stackTop - curproc->tf->ebp);
8010461a:	8b 73 18             	mov    0x18(%ebx),%esi
8010461d:	8b 4a 18             	mov    0x18(%edx),%ecx
80104620:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
80104626:	03 46 08             	add    0x8(%esi),%eax
80104629:	2b 83 80 00 00 00    	sub    0x80(%ebx),%eax
  for(i = 0; i < NOFILE; i++)
8010462f:	31 f6                	xor    %esi,%esi
  np->tf->ebp = np->stackTop - (curproc->stackTop - curproc->tf->ebp);
80104631:	89 41 08             	mov    %eax,0x8(%ecx)
  for(i = 0; i < NOFILE; i++)
80104634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104638:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010463c:	85 c0                	test   %eax,%eax
8010463e:	74 10                	je     80104650 <clone+0x110>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104640:	83 ec 0c             	sub    $0xc,%esp
80104643:	50                   	push   %eax
80104644:	e8 47 c8 ff ff       	call   80100e90 <filedup>
80104649:	83 c4 10             	add    $0x10,%esp
8010464c:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104650:	83 c6 01             	add    $0x1,%esi
80104653:	83 fe 10             	cmp    $0x10,%esi
80104656:	75 e0                	jne    80104638 <clone+0xf8>
  np->cwd = idup(curproc->cwd);
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010465e:	83 c3 6c             	add    $0x6c,%ebx
80104661:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  np->cwd = idup(curproc->cwd);
80104664:	e8 e7 d0 ff ff       	call   80101750 <idup>
80104669:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010466c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010466f:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104672:	8d 42 6c             	lea    0x6c(%edx),%eax
80104675:	6a 10                	push   $0x10
80104677:	53                   	push   %ebx
80104678:	50                   	push   %eax
80104679:	e8 32 07 00 00       	call   80104db0 <safestrcpy>

  pid = np->pid;
8010467e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104681:	8b 5a 10             	mov    0x10(%edx),%ebx

  acquire(&ptable.lock);
80104684:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
8010468b:	e8 50 04 00 00       	call   80104ae0 <acquire>

  np->state = RUNNABLE;
80104690:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104693:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)

  release(&ptable.lock);
8010469a:	c7 04 24 80 3d 11 80 	movl   $0x80113d80,(%esp)
801046a1:	e8 fa 04 00 00       	call   80104ba0 <release>

  return pid;
801046a6:	83 c4 10             	add    $0x10,%esp
}
801046a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046ac:	89 d8                	mov    %ebx,%eax
801046ae:	5b                   	pop    %ebx
801046af:	5e                   	pop    %esi
801046b0:	5f                   	pop    %edi
801046b1:	5d                   	pop    %ebp
801046b2:	c3                   	ret    
    return -1;
801046b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046b8:	eb ef                	jmp    801046a9 <clone+0x169>
801046ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046c0 <join>:


int
join(void)
{
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	56                   	push   %esi
801046c8:	53                   	push   %ebx
  pushcli();
801046c9:	e8 12 03 00 00       	call   801049e0 <pushcli>
  c = mycpu();
801046ce:	e8 4d f2 ff ff       	call   80103920 <mycpu>
  p = c->proc;
801046d3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801046d9:	e8 52 03 00 00       	call   80104a30 <popcli>
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
801046de:	83 ec 0c             	sub    $0xc,%esp
801046e1:	68 80 3d 11 80       	push   $0x80113d80
801046e6:	e8 f5 03 00 00       	call   80104ae0 <acquire>
801046eb:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
801046ee:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046f0:	bb b4 3d 11 80       	mov    $0x80113db4,%ebx
801046f5:	eb 17                	jmp    8010470e <join+0x4e>
801046f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046fe:	66 90                	xchg   %ax,%ax
80104700:	81 c3 88 00 00 00    	add    $0x88,%ebx
80104706:	81 fb b4 5f 11 80    	cmp    $0x80115fb4,%ebx
8010470c:	74 27                	je     80104735 <join+0x75>
      if(p->parent != curproc)
8010470e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104711:	75 ed                	jne    80104700 <join+0x40>
        continue;
      
      havekids = 1;
      
      if(p->threads != -1){
80104713:	83 bb 84 00 00 00 ff 	cmpl   $0xffffffff,0x84(%ebx)
8010471a:	75 06                	jne    80104722 <join+0x62>
        continue;
      }

      if(p->state == ZOMBIE){
8010471c:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104720:	74 3e                	je     80104760 <join+0xa0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104722:	81 c3 88 00 00 00    	add    $0x88,%ebx
      havekids = 1;
80104728:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010472d:	81 fb b4 5f 11 80    	cmp    $0x80115fb4,%ebx
80104733:	75 d9                	jne    8010470e <join+0x4e>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80104735:	85 c0                	test   %eax,%eax
80104737:	0f 84 c2 00 00 00    	je     801047ff <join+0x13f>
8010473d:	8b 46 24             	mov    0x24(%esi),%eax
80104740:	85 c0                	test   %eax,%eax
80104742:	0f 85 b7 00 00 00    	jne    801047ff <join+0x13f>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104748:	83 ec 08             	sub    $0x8,%esp
8010474b:	68 80 3d 11 80       	push   $0x80113d80
80104750:	56                   	push   %esi
80104751:	e8 9a f9 ff ff       	call   801040f0 <sleep>
    havekids = 0;
80104756:	83 c4 10             	add    $0x10,%esp
80104759:	eb 93                	jmp    801046ee <join+0x2e>
8010475b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010475f:	90                   	nop
        kfree(p->kstack);
80104760:	83 ec 0c             	sub    $0xc,%esp
80104763:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104766:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104769:	e8 22 dd ff ff       	call   80102490 <kfree>
        p->kstack = 0;
8010476e:	8b 53 04             	mov    0x4(%ebx),%edx
80104771:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
80104774:	b8 b4 3d 11 80       	mov    $0x80113db4,%eax
        p->kstack = 0;
80104779:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  for(p = ptable.proc; p<&ptable.proc[NPROC]; p++){
80104780:	eb 12                	jmp    80104794 <join+0xd4>
80104782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104788:	05 88 00 00 00       	add    $0x88,%eax
8010478d:	3d b4 5f 11 80       	cmp    $0x80115fb4,%eax
80104792:	74 5d                	je     801047f1 <join+0x131>
    if(p != process && p->pgdir == process->pgdir){
80104794:	39 c3                	cmp    %eax,%ebx
80104796:	74 f0                	je     80104788 <join+0xc8>
80104798:	39 50 04             	cmp    %edx,0x4(%eax)
8010479b:	75 eb                	jne    80104788 <join+0xc8>
        release(&ptable.lock);
8010479d:	83 ec 0c             	sub    $0xc,%esp
        p->pid = 0;
801047a0:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
801047a7:	68 80 3d 11 80       	push   $0x80113d80
        p->parent = 0;
801047ac:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801047b3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801047b7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801047be:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->stackTop = 0;
801047c5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801047cc:	00 00 00 
        p->pgdir = 0;
801047cf:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
        p->threads = -1;
801047d6:	c7 83 84 00 00 00 ff 	movl   $0xffffffff,0x84(%ebx)
801047dd:	ff ff ff 
        release(&ptable.lock);
801047e0:	e8 bb 03 00 00       	call   80104ba0 <release>
        return pid;
801047e5:	83 c4 10             	add    $0x10,%esp
  }
801047e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047eb:	89 f0                	mov    %esi,%eax
801047ed:	5b                   	pop    %ebx
801047ee:	5e                   	pop    %esi
801047ef:	5d                   	pop    %ebp
801047f0:	c3                   	ret    
          freevm(p->pgdir);
801047f1:	83 ec 0c             	sub    $0xc,%esp
801047f4:	52                   	push   %edx
801047f5:	e8 e6 2b 00 00       	call   801073e0 <freevm>
801047fa:	83 c4 10             	add    $0x10,%esp
801047fd:	eb 9e                	jmp    8010479d <join+0xdd>
      release(&ptable.lock);
801047ff:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104802:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104807:	68 80 3d 11 80       	push   $0x80113d80
8010480c:	e8 8f 03 00 00       	call   80104ba0 <release>
      return -1;
80104811:	83 c4 10             	add    $0x10,%esp
80104814:	eb d2                	jmp    801047e8 <join+0x128>
80104816:	66 90                	xchg   %ax,%ax
80104818:	66 90                	xchg   %ax,%ax
8010481a:	66 90                	xchg   %ax,%ax
8010481c:	66 90                	xchg   %ax,%ax
8010481e:	66 90                	xchg   %ax,%ax

80104820 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
80104825:	89 e5                	mov    %esp,%ebp
80104827:	53                   	push   %ebx
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010482e:	68 6c 7d 10 80       	push   $0x80107d6c
80104833:	8d 43 04             	lea    0x4(%ebx),%eax
80104836:	50                   	push   %eax
80104837:	e8 24 01 00 00       	call   80104960 <initlock>
  lk->name = name;
8010483c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010483f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104845:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104848:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010484f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104855:	c9                   	leave  
80104856:	c3                   	ret    
80104857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485e:	66 90                	xchg   %ax,%ax

80104860 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	56                   	push   %esi
80104868:	53                   	push   %ebx
80104869:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010486c:	8d 73 04             	lea    0x4(%ebx),%esi
8010486f:	83 ec 0c             	sub    $0xc,%esp
80104872:	56                   	push   %esi
80104873:	e8 68 02 00 00       	call   80104ae0 <acquire>
  while (lk->locked) {
80104878:	8b 13                	mov    (%ebx),%edx
8010487a:	83 c4 10             	add    $0x10,%esp
8010487d:	85 d2                	test   %edx,%edx
8010487f:	74 1a                	je     8010489b <acquiresleep+0x3b>
80104881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104888:	83 ec 08             	sub    $0x8,%esp
8010488b:	56                   	push   %esi
8010488c:	53                   	push   %ebx
8010488d:	e8 5e f8 ff ff       	call   801040f0 <sleep>
  while (lk->locked) {
80104892:	8b 03                	mov    (%ebx),%eax
80104894:	83 c4 10             	add    $0x10,%esp
80104897:	85 c0                	test   %eax,%eax
80104899:	75 ed                	jne    80104888 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010489b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801048a1:	e8 0a f1 ff ff       	call   801039b0 <myproc>
801048a6:	8b 40 10             	mov    0x10(%eax),%eax
801048a9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801048ac:	89 75 08             	mov    %esi,0x8(%ebp)
}
801048af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b2:	5b                   	pop    %ebx
801048b3:	5e                   	pop    %esi
801048b4:	5d                   	pop    %ebp
  release(&lk->lk);
801048b5:	e9 e6 02 00 00       	jmp    80104ba0 <release>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
801048c5:	89 e5                	mov    %esp,%ebp
801048c7:	56                   	push   %esi
801048c8:	53                   	push   %ebx
801048c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801048cc:	8d 73 04             	lea    0x4(%ebx),%esi
801048cf:	83 ec 0c             	sub    $0xc,%esp
801048d2:	56                   	push   %esi
801048d3:	e8 08 02 00 00       	call   80104ae0 <acquire>
  lk->locked = 0;
801048d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801048de:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801048e5:	89 1c 24             	mov    %ebx,(%esp)
801048e8:	e8 23 fa ff ff       	call   80104310 <wakeup>
  release(&lk->lk);
801048ed:	89 75 08             	mov    %esi,0x8(%ebp)
801048f0:	83 c4 10             	add    $0x10,%esp
}
801048f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048f6:	5b                   	pop    %ebx
801048f7:	5e                   	pop    %esi
801048f8:	5d                   	pop    %ebp
  release(&lk->lk);
801048f9:	e9 a2 02 00 00       	jmp    80104ba0 <release>
801048fe:	66 90                	xchg   %ax,%ax

80104900 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104900:	f3 0f 1e fb          	endbr32 
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	57                   	push   %edi
80104908:	31 ff                	xor    %edi,%edi
8010490a:	56                   	push   %esi
8010490b:	53                   	push   %ebx
8010490c:	83 ec 18             	sub    $0x18,%esp
8010490f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104912:	8d 73 04             	lea    0x4(%ebx),%esi
80104915:	56                   	push   %esi
80104916:	e8 c5 01 00 00       	call   80104ae0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010491b:	8b 03                	mov    (%ebx),%eax
8010491d:	83 c4 10             	add    $0x10,%esp
80104920:	85 c0                	test   %eax,%eax
80104922:	75 1c                	jne    80104940 <holdingsleep+0x40>
  release(&lk->lk);
80104924:	83 ec 0c             	sub    $0xc,%esp
80104927:	56                   	push   %esi
80104928:	e8 73 02 00 00       	call   80104ba0 <release>
  return r;
}
8010492d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104930:	89 f8                	mov    %edi,%eax
80104932:	5b                   	pop    %ebx
80104933:	5e                   	pop    %esi
80104934:	5f                   	pop    %edi
80104935:	5d                   	pop    %ebp
80104936:	c3                   	ret    
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104940:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104943:	e8 68 f0 ff ff       	call   801039b0 <myproc>
80104948:	39 58 10             	cmp    %ebx,0x10(%eax)
8010494b:	0f 94 c0             	sete   %al
8010494e:	0f b6 c0             	movzbl %al,%eax
80104951:	89 c7                	mov    %eax,%edi
80104953:	eb cf                	jmp    80104924 <holdingsleep+0x24>
80104955:	66 90                	xchg   %ax,%ax
80104957:	66 90                	xchg   %ax,%ax
80104959:	66 90                	xchg   %ax,%ax
8010495b:	66 90                	xchg   %ax,%ax
8010495d:	66 90                	xchg   %ax,%ax
8010495f:	90                   	nop

80104960 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
80104965:	89 e5                	mov    %esp,%ebp
80104967:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010496a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010496d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104973:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104976:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010497d:	5d                   	pop    %ebp
8010497e:	c3                   	ret    
8010497f:	90                   	nop

80104980 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104980:	f3 0f 1e fb          	endbr32 
80104984:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104985:	31 d2                	xor    %edx,%edx
{
80104987:	89 e5                	mov    %esp,%ebp
80104989:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010498a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010498d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104990:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104993:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104997:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104998:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010499e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801049a4:	77 1a                	ja     801049c0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801049a6:	8b 58 04             	mov    0x4(%eax),%ebx
801049a9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801049ac:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801049af:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049b1:	83 fa 0a             	cmp    $0xa,%edx
801049b4:	75 e2                	jne    80104998 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801049b6:	5b                   	pop    %ebx
801049b7:	5d                   	pop    %ebp
801049b8:	c3                   	ret    
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801049c0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801049c3:	8d 51 28             	lea    0x28(%ecx),%edx
801049c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049cd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801049d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801049d6:	83 c0 04             	add    $0x4,%eax
801049d9:	39 d0                	cmp    %edx,%eax
801049db:	75 f3                	jne    801049d0 <getcallerpcs+0x50>
}
801049dd:	5b                   	pop    %ebx
801049de:	5d                   	pop    %ebp
801049df:	c3                   	ret    

801049e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	53                   	push   %ebx
801049e8:	83 ec 04             	sub    $0x4,%esp
801049eb:	9c                   	pushf  
801049ec:	5b                   	pop    %ebx
  asm volatile("cli");
801049ed:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801049ee:	e8 2d ef ff ff       	call   80103920 <mycpu>
801049f3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049f9:	85 c0                	test   %eax,%eax
801049fb:	74 13                	je     80104a10 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801049fd:	e8 1e ef ff ff       	call   80103920 <mycpu>
80104a02:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104a09:	83 c4 04             	add    $0x4,%esp
80104a0c:	5b                   	pop    %ebx
80104a0d:	5d                   	pop    %ebp
80104a0e:	c3                   	ret    
80104a0f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104a10:	e8 0b ef ff ff       	call   80103920 <mycpu>
80104a15:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104a1b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104a21:	eb da                	jmp    801049fd <pushcli+0x1d>
80104a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a30 <popcli>:

void
popcli(void)
{
80104a30:	f3 0f 1e fb          	endbr32 
80104a34:	55                   	push   %ebp
80104a35:	89 e5                	mov    %esp,%ebp
80104a37:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a3a:	9c                   	pushf  
80104a3b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104a3c:	f6 c4 02             	test   $0x2,%ah
80104a3f:	75 31                	jne    80104a72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104a41:	e8 da ee ff ff       	call   80103920 <mycpu>
80104a46:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104a4d:	78 30                	js     80104a7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a4f:	e8 cc ee ff ff       	call   80103920 <mycpu>
80104a54:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a5a:	85 d2                	test   %edx,%edx
80104a5c:	74 02                	je     80104a60 <popcli+0x30>
    sti();
}
80104a5e:	c9                   	leave  
80104a5f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a60:	e8 bb ee ff ff       	call   80103920 <mycpu>
80104a65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a6b:	85 c0                	test   %eax,%eax
80104a6d:	74 ef                	je     80104a5e <popcli+0x2e>
  asm volatile("sti");
80104a6f:	fb                   	sti    
}
80104a70:	c9                   	leave  
80104a71:	c3                   	ret    
    panic("popcli - interruptible");
80104a72:	83 ec 0c             	sub    $0xc,%esp
80104a75:	68 77 7d 10 80       	push   $0x80107d77
80104a7a:	e8 11 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
80104a7f:	83 ec 0c             	sub    $0xc,%esp
80104a82:	68 8e 7d 10 80       	push   $0x80107d8e
80104a87:	e8 04 b9 ff ff       	call   80100390 <panic>
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <holding>:
{
80104a90:	f3 0f 1e fb          	endbr32 
80104a94:	55                   	push   %ebp
80104a95:	89 e5                	mov    %esp,%ebp
80104a97:	56                   	push   %esi
80104a98:	53                   	push   %ebx
80104a99:	8b 75 08             	mov    0x8(%ebp),%esi
80104a9c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104a9e:	e8 3d ff ff ff       	call   801049e0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104aa3:	8b 06                	mov    (%esi),%eax
80104aa5:	85 c0                	test   %eax,%eax
80104aa7:	75 0f                	jne    80104ab8 <holding+0x28>
  popcli();
80104aa9:	e8 82 ff ff ff       	call   80104a30 <popcli>
}
80104aae:	89 d8                	mov    %ebx,%eax
80104ab0:	5b                   	pop    %ebx
80104ab1:	5e                   	pop    %esi
80104ab2:	5d                   	pop    %ebp
80104ab3:	c3                   	ret    
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104ab8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104abb:	e8 60 ee ff ff       	call   80103920 <mycpu>
80104ac0:	39 c3                	cmp    %eax,%ebx
80104ac2:	0f 94 c3             	sete   %bl
  popcli();
80104ac5:	e8 66 ff ff ff       	call   80104a30 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104aca:	0f b6 db             	movzbl %bl,%ebx
}
80104acd:	89 d8                	mov    %ebx,%eax
80104acf:	5b                   	pop    %ebx
80104ad0:	5e                   	pop    %esi
80104ad1:	5d                   	pop    %ebp
80104ad2:	c3                   	ret    
80104ad3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ae0 <acquire>:
{
80104ae0:	f3 0f 1e fb          	endbr32 
80104ae4:	55                   	push   %ebp
80104ae5:	89 e5                	mov    %esp,%ebp
80104ae7:	56                   	push   %esi
80104ae8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104ae9:	e8 f2 fe ff ff       	call   801049e0 <pushcli>
  if(holding(lk))
80104aee:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104af1:	83 ec 0c             	sub    $0xc,%esp
80104af4:	53                   	push   %ebx
80104af5:	e8 96 ff ff ff       	call   80104a90 <holding>
80104afa:	83 c4 10             	add    $0x10,%esp
80104afd:	85 c0                	test   %eax,%eax
80104aff:	0f 85 7f 00 00 00    	jne    80104b84 <acquire+0xa4>
80104b05:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104b07:	ba 01 00 00 00       	mov    $0x1,%edx
80104b0c:	eb 05                	jmp    80104b13 <acquire+0x33>
80104b0e:	66 90                	xchg   %ax,%ax
80104b10:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b13:	89 d0                	mov    %edx,%eax
80104b15:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104b18:	85 c0                	test   %eax,%eax
80104b1a:	75 f4                	jne    80104b10 <acquire+0x30>
  __sync_synchronize();
80104b1c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104b21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104b24:	e8 f7 ed ff ff       	call   80103920 <mycpu>
80104b29:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104b2c:	89 e8                	mov    %ebp,%eax
80104b2e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b30:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104b36:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104b3c:	77 22                	ja     80104b60 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104b3e:	8b 50 04             	mov    0x4(%eax),%edx
80104b41:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104b45:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104b48:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b4a:	83 fe 0a             	cmp    $0xa,%esi
80104b4d:	75 e1                	jne    80104b30 <acquire+0x50>
}
80104b4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b52:	5b                   	pop    %ebx
80104b53:	5e                   	pop    %esi
80104b54:	5d                   	pop    %ebp
80104b55:	c3                   	ret    
80104b56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b5d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104b60:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104b64:	83 c3 34             	add    $0x34,%ebx
80104b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104b76:	83 c0 04             	add    $0x4,%eax
80104b79:	39 d8                	cmp    %ebx,%eax
80104b7b:	75 f3                	jne    80104b70 <acquire+0x90>
}
80104b7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b80:	5b                   	pop    %ebx
80104b81:	5e                   	pop    %esi
80104b82:	5d                   	pop    %ebp
80104b83:	c3                   	ret    
    panic("acquire");
80104b84:	83 ec 0c             	sub    $0xc,%esp
80104b87:	68 95 7d 10 80       	push   $0x80107d95
80104b8c:	e8 ff b7 ff ff       	call   80100390 <panic>
80104b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b9f:	90                   	nop

80104ba0 <release>:
{
80104ba0:	f3 0f 1e fb          	endbr32 
80104ba4:	55                   	push   %ebp
80104ba5:	89 e5                	mov    %esp,%ebp
80104ba7:	53                   	push   %ebx
80104ba8:	83 ec 10             	sub    $0x10,%esp
80104bab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104bae:	53                   	push   %ebx
80104baf:	e8 dc fe ff ff       	call   80104a90 <holding>
80104bb4:	83 c4 10             	add    $0x10,%esp
80104bb7:	85 c0                	test   %eax,%eax
80104bb9:	74 22                	je     80104bdd <release+0x3d>
  lk->pcs[0] = 0;
80104bbb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104bc2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104bc9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104bce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd7:	c9                   	leave  
  popcli();
80104bd8:	e9 53 fe ff ff       	jmp    80104a30 <popcli>
    panic("release");
80104bdd:	83 ec 0c             	sub    $0xc,%esp
80104be0:	68 9d 7d 10 80       	push   $0x80107d9d
80104be5:	e8 a6 b7 ff ff       	call   80100390 <panic>
80104bea:	66 90                	xchg   %ax,%ax
80104bec:	66 90                	xchg   %ax,%ax
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104bf0:	f3 0f 1e fb          	endbr32 
80104bf4:	55                   	push   %ebp
80104bf5:	89 e5                	mov    %esp,%ebp
80104bf7:	57                   	push   %edi
80104bf8:	8b 55 08             	mov    0x8(%ebp),%edx
80104bfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bfe:	53                   	push   %ebx
80104bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104c02:	89 d7                	mov    %edx,%edi
80104c04:	09 cf                	or     %ecx,%edi
80104c06:	83 e7 03             	and    $0x3,%edi
80104c09:	75 25                	jne    80104c30 <memset+0x40>
    c &= 0xFF;
80104c0b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104c0e:	c1 e0 18             	shl    $0x18,%eax
80104c11:	89 fb                	mov    %edi,%ebx
80104c13:	c1 e9 02             	shr    $0x2,%ecx
80104c16:	c1 e3 10             	shl    $0x10,%ebx
80104c19:	09 d8                	or     %ebx,%eax
80104c1b:	09 f8                	or     %edi,%eax
80104c1d:	c1 e7 08             	shl    $0x8,%edi
80104c20:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104c22:	89 d7                	mov    %edx,%edi
80104c24:	fc                   	cld    
80104c25:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104c27:	5b                   	pop    %ebx
80104c28:	89 d0                	mov    %edx,%eax
80104c2a:	5f                   	pop    %edi
80104c2b:	5d                   	pop    %ebp
80104c2c:	c3                   	ret    
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104c30:	89 d7                	mov    %edx,%edi
80104c32:	fc                   	cld    
80104c33:	f3 aa                	rep stos %al,%es:(%edi)
80104c35:	5b                   	pop    %ebx
80104c36:	89 d0                	mov    %edx,%eax
80104c38:	5f                   	pop    %edi
80104c39:	5d                   	pop    %ebp
80104c3a:	c3                   	ret    
80104c3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c3f:	90                   	nop

80104c40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104c40:	f3 0f 1e fb          	endbr32 
80104c44:	55                   	push   %ebp
80104c45:	89 e5                	mov    %esp,%ebp
80104c47:	56                   	push   %esi
80104c48:	8b 75 10             	mov    0x10(%ebp),%esi
80104c4b:	8b 55 08             	mov    0x8(%ebp),%edx
80104c4e:	53                   	push   %ebx
80104c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104c52:	85 f6                	test   %esi,%esi
80104c54:	74 2a                	je     80104c80 <memcmp+0x40>
80104c56:	01 c6                	add    %eax,%esi
80104c58:	eb 10                	jmp    80104c6a <memcmp+0x2a>
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104c60:	83 c0 01             	add    $0x1,%eax
80104c63:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104c66:	39 f0                	cmp    %esi,%eax
80104c68:	74 16                	je     80104c80 <memcmp+0x40>
    if(*s1 != *s2)
80104c6a:	0f b6 0a             	movzbl (%edx),%ecx
80104c6d:	0f b6 18             	movzbl (%eax),%ebx
80104c70:	38 d9                	cmp    %bl,%cl
80104c72:	74 ec                	je     80104c60 <memcmp+0x20>
      return *s1 - *s2;
80104c74:	0f b6 c1             	movzbl %cl,%eax
80104c77:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104c79:	5b                   	pop    %ebx
80104c7a:	5e                   	pop    %esi
80104c7b:	5d                   	pop    %ebp
80104c7c:	c3                   	ret    
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
80104c80:	5b                   	pop    %ebx
  return 0;
80104c81:	31 c0                	xor    %eax,%eax
}
80104c83:	5e                   	pop    %esi
80104c84:	5d                   	pop    %ebp
80104c85:	c3                   	ret    
80104c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi

80104c90 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104c90:	f3 0f 1e fb          	endbr32 
80104c94:	55                   	push   %ebp
80104c95:	89 e5                	mov    %esp,%ebp
80104c97:	57                   	push   %edi
80104c98:	8b 55 08             	mov    0x8(%ebp),%edx
80104c9b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c9e:	56                   	push   %esi
80104c9f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ca2:	39 d6                	cmp    %edx,%esi
80104ca4:	73 2a                	jae    80104cd0 <memmove+0x40>
80104ca6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ca9:	39 fa                	cmp    %edi,%edx
80104cab:	73 23                	jae    80104cd0 <memmove+0x40>
80104cad:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104cb0:	85 c9                	test   %ecx,%ecx
80104cb2:	74 13                	je     80104cc7 <memmove+0x37>
80104cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104cb8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104cbc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104cbf:	83 e8 01             	sub    $0x1,%eax
80104cc2:	83 f8 ff             	cmp    $0xffffffff,%eax
80104cc5:	75 f1                	jne    80104cb8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104cc7:	5e                   	pop    %esi
80104cc8:	89 d0                	mov    %edx,%eax
80104cca:	5f                   	pop    %edi
80104ccb:	5d                   	pop    %ebp
80104ccc:	c3                   	ret    
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104cd0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104cd3:	89 d7                	mov    %edx,%edi
80104cd5:	85 c9                	test   %ecx,%ecx
80104cd7:	74 ee                	je     80104cc7 <memmove+0x37>
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ce0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ce1:	39 f0                	cmp    %esi,%eax
80104ce3:	75 fb                	jne    80104ce0 <memmove+0x50>
}
80104ce5:	5e                   	pop    %esi
80104ce6:	89 d0                	mov    %edx,%eax
80104ce8:	5f                   	pop    %edi
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    
80104ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cef:	90                   	nop

80104cf0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104cf0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104cf4:	eb 9a                	jmp    80104c90 <memmove>
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi

80104d00 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104d00:	f3 0f 1e fb          	endbr32 
80104d04:	55                   	push   %ebp
80104d05:	89 e5                	mov    %esp,%ebp
80104d07:	56                   	push   %esi
80104d08:	8b 75 10             	mov    0x10(%ebp),%esi
80104d0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d0e:	53                   	push   %ebx
80104d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104d12:	85 f6                	test   %esi,%esi
80104d14:	74 32                	je     80104d48 <strncmp+0x48>
80104d16:	01 c6                	add    %eax,%esi
80104d18:	eb 14                	jmp    80104d2e <strncmp+0x2e>
80104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d20:	38 da                	cmp    %bl,%dl
80104d22:	75 14                	jne    80104d38 <strncmp+0x38>
    n--, p++, q++;
80104d24:	83 c0 01             	add    $0x1,%eax
80104d27:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104d2a:	39 f0                	cmp    %esi,%eax
80104d2c:	74 1a                	je     80104d48 <strncmp+0x48>
80104d2e:	0f b6 11             	movzbl (%ecx),%edx
80104d31:	0f b6 18             	movzbl (%eax),%ebx
80104d34:	84 d2                	test   %dl,%dl
80104d36:	75 e8                	jne    80104d20 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104d38:	0f b6 c2             	movzbl %dl,%eax
80104d3b:	29 d8                	sub    %ebx,%eax
}
80104d3d:	5b                   	pop    %ebx
80104d3e:	5e                   	pop    %esi
80104d3f:	5d                   	pop    %ebp
80104d40:	c3                   	ret    
80104d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d48:	5b                   	pop    %ebx
    return 0;
80104d49:	31 c0                	xor    %eax,%eax
}
80104d4b:	5e                   	pop    %esi
80104d4c:	5d                   	pop    %ebp
80104d4d:	c3                   	ret    
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	57                   	push   %edi
80104d58:	56                   	push   %esi
80104d59:	8b 75 08             	mov    0x8(%ebp),%esi
80104d5c:	53                   	push   %ebx
80104d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104d60:	89 f2                	mov    %esi,%edx
80104d62:	eb 1b                	jmp    80104d7f <strncpy+0x2f>
80104d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d68:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104d6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104d6f:	83 c2 01             	add    $0x1,%edx
80104d72:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104d76:	89 f9                	mov    %edi,%ecx
80104d78:	88 4a ff             	mov    %cl,-0x1(%edx)
80104d7b:	84 c9                	test   %cl,%cl
80104d7d:	74 09                	je     80104d88 <strncpy+0x38>
80104d7f:	89 c3                	mov    %eax,%ebx
80104d81:	83 e8 01             	sub    $0x1,%eax
80104d84:	85 db                	test   %ebx,%ebx
80104d86:	7f e0                	jg     80104d68 <strncpy+0x18>
    ;
  while(n-- > 0)
80104d88:	89 d1                	mov    %edx,%ecx
80104d8a:	85 c0                	test   %eax,%eax
80104d8c:	7e 15                	jle    80104da3 <strncpy+0x53>
80104d8e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104d90:	83 c1 01             	add    $0x1,%ecx
80104d93:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104d97:	89 c8                	mov    %ecx,%eax
80104d99:	f7 d0                	not    %eax
80104d9b:	01 d0                	add    %edx,%eax
80104d9d:	01 d8                	add    %ebx,%eax
80104d9f:	85 c0                	test   %eax,%eax
80104da1:	7f ed                	jg     80104d90 <strncpy+0x40>
  return os;
}
80104da3:	5b                   	pop    %ebx
80104da4:	89 f0                	mov    %esi,%eax
80104da6:	5e                   	pop    %esi
80104da7:	5f                   	pop    %edi
80104da8:	5d                   	pop    %ebp
80104da9:	c3                   	ret    
80104daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104db0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104db0:	f3 0f 1e fb          	endbr32 
80104db4:	55                   	push   %ebp
80104db5:	89 e5                	mov    %esp,%ebp
80104db7:	56                   	push   %esi
80104db8:	8b 55 10             	mov    0x10(%ebp),%edx
80104dbb:	8b 75 08             	mov    0x8(%ebp),%esi
80104dbe:	53                   	push   %ebx
80104dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104dc2:	85 d2                	test   %edx,%edx
80104dc4:	7e 21                	jle    80104de7 <safestrcpy+0x37>
80104dc6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104dca:	89 f2                	mov    %esi,%edx
80104dcc:	eb 12                	jmp    80104de0 <safestrcpy+0x30>
80104dce:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104dd0:	0f b6 08             	movzbl (%eax),%ecx
80104dd3:	83 c0 01             	add    $0x1,%eax
80104dd6:	83 c2 01             	add    $0x1,%edx
80104dd9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ddc:	84 c9                	test   %cl,%cl
80104dde:	74 04                	je     80104de4 <safestrcpy+0x34>
80104de0:	39 d8                	cmp    %ebx,%eax
80104de2:	75 ec                	jne    80104dd0 <safestrcpy+0x20>
    ;
  *s = 0;
80104de4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104de7:	89 f0                	mov    %esi,%eax
80104de9:	5b                   	pop    %ebx
80104dea:	5e                   	pop    %esi
80104deb:	5d                   	pop    %ebp
80104dec:	c3                   	ret    
80104ded:	8d 76 00             	lea    0x0(%esi),%esi

80104df0 <strlen>:

int
strlen(const char *s)
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104df5:	31 c0                	xor    %eax,%eax
{
80104df7:	89 e5                	mov    %esp,%ebp
80104df9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104dfc:	80 3a 00             	cmpb   $0x0,(%edx)
80104dff:	74 10                	je     80104e11 <strlen+0x21>
80104e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e08:	83 c0 01             	add    $0x1,%eax
80104e0b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104e0f:	75 f7                	jne    80104e08 <strlen+0x18>
    ;
  return n;
}
80104e11:	5d                   	pop    %ebp
80104e12:	c3                   	ret    

80104e13 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104e13:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104e17:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104e1b:	55                   	push   %ebp
  pushl %ebx
80104e1c:	53                   	push   %ebx
  pushl %esi
80104e1d:	56                   	push   %esi
  pushl %edi
80104e1e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104e1f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104e21:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104e23:	5f                   	pop    %edi
  popl %esi
80104e24:	5e                   	pop    %esi
  popl %ebx
80104e25:	5b                   	pop    %ebx
  popl %ebp
80104e26:	5d                   	pop    %ebp
  ret
80104e27:	c3                   	ret    
80104e28:	66 90                	xchg   %ax,%ax
80104e2a:	66 90                	xchg   %ax,%ax
80104e2c:	66 90                	xchg   %ax,%ax
80104e2e:	66 90                	xchg   %ax,%ax

80104e30 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104e30:	f3 0f 1e fb          	endbr32 
80104e34:	55                   	push   %ebp
80104e35:	89 e5                	mov    %esp,%ebp
80104e37:	53                   	push   %ebx
80104e38:	83 ec 04             	sub    $0x4,%esp
80104e3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104e3e:	e8 6d eb ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104e43:	8b 00                	mov    (%eax),%eax
80104e45:	39 d8                	cmp    %ebx,%eax
80104e47:	76 17                	jbe    80104e60 <fetchint+0x30>
80104e49:	8d 53 04             	lea    0x4(%ebx),%edx
80104e4c:	39 d0                	cmp    %edx,%eax
80104e4e:	72 10                	jb     80104e60 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104e50:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e53:	8b 13                	mov    (%ebx),%edx
80104e55:	89 10                	mov    %edx,(%eax)
  return 0;
80104e57:	31 c0                	xor    %eax,%eax
}
80104e59:	83 c4 04             	add    $0x4,%esp
80104e5c:	5b                   	pop    %ebx
80104e5d:	5d                   	pop    %ebp
80104e5e:	c3                   	ret    
80104e5f:	90                   	nop
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e65:	eb f2                	jmp    80104e59 <fetchint+0x29>
80104e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e6e:	66 90                	xchg   %ax,%ax

80104e70 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104e70:	f3 0f 1e fb          	endbr32 
80104e74:	55                   	push   %ebp
80104e75:	89 e5                	mov    %esp,%ebp
80104e77:	53                   	push   %ebx
80104e78:	83 ec 04             	sub    $0x4,%esp
80104e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104e7e:	e8 2d eb ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz)
80104e83:	39 18                	cmp    %ebx,(%eax)
80104e85:	76 31                	jbe    80104eb8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104e87:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e8a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104e8c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104e8e:	39 d3                	cmp    %edx,%ebx
80104e90:	73 26                	jae    80104eb8 <fetchstr+0x48>
80104e92:	89 d8                	mov    %ebx,%eax
80104e94:	eb 11                	jmp    80104ea7 <fetchstr+0x37>
80104e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ea0:	83 c0 01             	add    $0x1,%eax
80104ea3:	39 c2                	cmp    %eax,%edx
80104ea5:	76 11                	jbe    80104eb8 <fetchstr+0x48>
    if(*s == 0)
80104ea7:	80 38 00             	cmpb   $0x0,(%eax)
80104eaa:	75 f4                	jne    80104ea0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104eac:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104eaf:	29 d8                	sub    %ebx,%eax
}
80104eb1:	5b                   	pop    %ebx
80104eb2:	5d                   	pop    %ebp
80104eb3:	c3                   	ret    
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eb8:	83 c4 04             	add    $0x4,%esp
    return -1;
80104ebb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ec0:	5b                   	pop    %ebx
80104ec1:	5d                   	pop    %ebp
80104ec2:	c3                   	ret    
80104ec3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ed0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ed0:	f3 0f 1e fb          	endbr32 
80104ed4:	55                   	push   %ebp
80104ed5:	89 e5                	mov    %esp,%ebp
80104ed7:	56                   	push   %esi
80104ed8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ed9:	e8 d2 ea ff ff       	call   801039b0 <myproc>
80104ede:	8b 55 08             	mov    0x8(%ebp),%edx
80104ee1:	8b 40 18             	mov    0x18(%eax),%eax
80104ee4:	8b 40 44             	mov    0x44(%eax),%eax
80104ee7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104eea:	e8 c1 ea ff ff       	call   801039b0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104eef:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ef2:	8b 00                	mov    (%eax),%eax
80104ef4:	39 c6                	cmp    %eax,%esi
80104ef6:	73 18                	jae    80104f10 <argint+0x40>
80104ef8:	8d 53 08             	lea    0x8(%ebx),%edx
80104efb:	39 d0                	cmp    %edx,%eax
80104efd:	72 11                	jb     80104f10 <argint+0x40>
  *ip = *(int*)(addr);
80104eff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f02:	8b 53 04             	mov    0x4(%ebx),%edx
80104f05:	89 10                	mov    %edx,(%eax)
  return 0;
80104f07:	31 c0                	xor    %eax,%eax
}
80104f09:	5b                   	pop    %ebx
80104f0a:	5e                   	pop    %esi
80104f0b:	5d                   	pop    %ebp
80104f0c:	c3                   	ret    
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104f15:	eb f2                	jmp    80104f09 <argint+0x39>
80104f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f1e:	66 90                	xchg   %ax,%ax

80104f20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104f20:	f3 0f 1e fb          	endbr32 
80104f24:	55                   	push   %ebp
80104f25:	89 e5                	mov    %esp,%ebp
80104f27:	56                   	push   %esi
80104f28:	53                   	push   %ebx
80104f29:	83 ec 10             	sub    $0x10,%esp
80104f2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104f2f:	e8 7c ea ff ff       	call   801039b0 <myproc>
 
  if(argint(n, &i) < 0)
80104f34:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104f37:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104f39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f3c:	50                   	push   %eax
80104f3d:	ff 75 08             	pushl  0x8(%ebp)
80104f40:	e8 8b ff ff ff       	call   80104ed0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104f45:	83 c4 10             	add    $0x10,%esp
80104f48:	85 c0                	test   %eax,%eax
80104f4a:	78 24                	js     80104f70 <argptr+0x50>
80104f4c:	85 db                	test   %ebx,%ebx
80104f4e:	78 20                	js     80104f70 <argptr+0x50>
80104f50:	8b 16                	mov    (%esi),%edx
80104f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f55:	39 c2                	cmp    %eax,%edx
80104f57:	76 17                	jbe    80104f70 <argptr+0x50>
80104f59:	01 c3                	add    %eax,%ebx
80104f5b:	39 da                	cmp    %ebx,%edx
80104f5d:	72 11                	jb     80104f70 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f62:	89 02                	mov    %eax,(%edx)
  return 0;
80104f64:	31 c0                	xor    %eax,%eax
}
80104f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f69:	5b                   	pop    %ebx
80104f6a:	5e                   	pop    %esi
80104f6b:	5d                   	pop    %ebp
80104f6c:	c3                   	ret    
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f75:	eb ef                	jmp    80104f66 <argptr+0x46>
80104f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104f80:	f3 0f 1e fb          	endbr32 
80104f84:	55                   	push   %ebp
80104f85:	89 e5                	mov    %esp,%ebp
80104f87:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104f8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f8d:	50                   	push   %eax
80104f8e:	ff 75 08             	pushl  0x8(%ebp)
80104f91:	e8 3a ff ff ff       	call   80104ed0 <argint>
80104f96:	83 c4 10             	add    $0x10,%esp
80104f99:	85 c0                	test   %eax,%eax
80104f9b:	78 13                	js     80104fb0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104f9d:	83 ec 08             	sub    $0x8,%esp
80104fa0:	ff 75 0c             	pushl  0xc(%ebp)
80104fa3:	ff 75 f4             	pushl  -0xc(%ebp)
80104fa6:	e8 c5 fe ff ff       	call   80104e70 <fetchstr>
80104fab:	83 c4 10             	add    $0x10,%esp
}
80104fae:	c9                   	leave  
80104faf:	c3                   	ret    
80104fb0:	c9                   	leave  
    return -1;
80104fb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fb6:	c3                   	ret    
80104fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fbe:	66 90                	xchg   %ax,%ax

80104fc0 <syscall>:
[SYS_join]   sys_join,
};

void
syscall(void)
{
80104fc0:	f3 0f 1e fb          	endbr32 
80104fc4:	55                   	push   %ebp
80104fc5:	89 e5                	mov    %esp,%ebp
80104fc7:	53                   	push   %ebx
80104fc8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104fcb:	e8 e0 e9 ff ff       	call   801039b0 <myproc>
80104fd0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104fd2:	8b 40 18             	mov    0x18(%eax),%eax
80104fd5:	8b 40 1c             	mov    0x1c(%eax),%eax
  //change to the code
  if(num == SYS_read){
80104fd8:	83 f8 05             	cmp    $0x5,%eax
80104fdb:	74 5b                	je     80105038 <syscall+0x78>
    readcount++;
  }
  if(num == SYS_getReadCount){
80104fdd:	83 f8 17             	cmp    $0x17,%eax
80104fe0:	75 26                	jne    80105008 <syscall+0x48>
    curproc->readid = readcount;
80104fe2:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80104fe8:	89 53 7c             	mov    %edx,0x7c(%ebx)
  }
  //
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104feb:	8b 14 85 e0 7d 10 80 	mov    -0x7fef8220(,%eax,4),%edx
    curproc->tf->eax = syscalls[num]();
80104ff2:	ff d2                	call   *%edx
80104ff4:	89 c2                	mov    %eax,%edx
80104ff6:	8b 43 18             	mov    0x18(%ebx),%eax
80104ff9:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ffc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fff:	c9                   	leave  
80105000:	c3                   	ret    
80105001:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105008:	8d 50 ff             	lea    -0x1(%eax),%edx
8010500b:	83 fa 18             	cmp    $0x18,%edx
8010500e:	76 31                	jbe    80105041 <syscall+0x81>
    cprintf("%d %s: unknown sys call %d\n",
80105010:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105011:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105014:	50                   	push   %eax
80105015:	ff 73 10             	pushl  0x10(%ebx)
80105018:	68 a5 7d 10 80       	push   $0x80107da5
8010501d:	e8 8e b6 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105022:	8b 43 18             	mov    0x18(%ebx),%eax
80105025:	83 c4 10             	add    $0x10,%esp
80105028:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010502f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105032:	c9                   	leave  
80105033:	c3                   	ret    
80105034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    readcount++;
80105038:	83 05 bc b5 10 80 01 	addl   $0x1,0x8010b5bc
  if(num == SYS_getReadCount){
8010503f:	eb aa                	jmp    80104feb <syscall+0x2b>
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105041:	8b 14 85 e0 7d 10 80 	mov    -0x7fef8220(,%eax,4),%edx
80105048:	85 d2                	test   %edx,%edx
8010504a:	74 c4                	je     80105010 <syscall+0x50>
8010504c:	eb a4                	jmp    80104ff2 <syscall+0x32>
8010504e:	66 90                	xchg   %ax,%ax

80105050 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	57                   	push   %edi
80105054:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105055:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105058:	53                   	push   %ebx
80105059:	83 ec 34             	sub    $0x34,%esp
8010505c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010505f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105062:	57                   	push   %edi
80105063:	50                   	push   %eax
{
80105064:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105067:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010506a:	e8 01 d0 ff ff       	call   80102070 <nameiparent>
8010506f:	83 c4 10             	add    $0x10,%esp
80105072:	85 c0                	test   %eax,%eax
80105074:	0f 84 46 01 00 00    	je     801051c0 <create+0x170>
    return 0;
  ilock(dp);
8010507a:	83 ec 0c             	sub    $0xc,%esp
8010507d:	89 c3                	mov    %eax,%ebx
8010507f:	50                   	push   %eax
80105080:	e8 fb c6 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105085:	83 c4 0c             	add    $0xc,%esp
80105088:	6a 00                	push   $0x0
8010508a:	57                   	push   %edi
8010508b:	53                   	push   %ebx
8010508c:	e8 3f cc ff ff       	call   80101cd0 <dirlookup>
80105091:	83 c4 10             	add    $0x10,%esp
80105094:	89 c6                	mov    %eax,%esi
80105096:	85 c0                	test   %eax,%eax
80105098:	74 56                	je     801050f0 <create+0xa0>
    iunlockput(dp);
8010509a:	83 ec 0c             	sub    $0xc,%esp
8010509d:	53                   	push   %ebx
8010509e:	e8 7d c9 ff ff       	call   80101a20 <iunlockput>
    ilock(ip);
801050a3:	89 34 24             	mov    %esi,(%esp)
801050a6:	e8 d5 c6 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801050ab:	83 c4 10             	add    $0x10,%esp
801050ae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801050b3:	75 1b                	jne    801050d0 <create+0x80>
801050b5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801050ba:	75 14                	jne    801050d0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801050bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050bf:	89 f0                	mov    %esi,%eax
801050c1:	5b                   	pop    %ebx
801050c2:	5e                   	pop    %esi
801050c3:	5f                   	pop    %edi
801050c4:	5d                   	pop    %ebp
801050c5:	c3                   	ret    
801050c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801050d0:	83 ec 0c             	sub    $0xc,%esp
801050d3:	56                   	push   %esi
    return 0;
801050d4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801050d6:	e8 45 c9 ff ff       	call   80101a20 <iunlockput>
    return 0;
801050db:	83 c4 10             	add    $0x10,%esp
}
801050de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050e1:	89 f0                	mov    %esi,%eax
801050e3:	5b                   	pop    %ebx
801050e4:	5e                   	pop    %esi
801050e5:	5f                   	pop    %edi
801050e6:	5d                   	pop    %ebp
801050e7:	c3                   	ret    
801050e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ef:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801050f0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801050f4:	83 ec 08             	sub    $0x8,%esp
801050f7:	50                   	push   %eax
801050f8:	ff 33                	pushl  (%ebx)
801050fa:	e8 01 c5 ff ff       	call   80101600 <ialloc>
801050ff:	83 c4 10             	add    $0x10,%esp
80105102:	89 c6                	mov    %eax,%esi
80105104:	85 c0                	test   %eax,%eax
80105106:	0f 84 cd 00 00 00    	je     801051d9 <create+0x189>
  ilock(ip);
8010510c:	83 ec 0c             	sub    $0xc,%esp
8010510f:	50                   	push   %eax
80105110:	e8 6b c6 ff ff       	call   80101780 <ilock>
  ip->major = major;
80105115:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105119:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010511d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105121:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105125:	b8 01 00 00 00       	mov    $0x1,%eax
8010512a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010512e:	89 34 24             	mov    %esi,(%esp)
80105131:	e8 8a c5 ff ff       	call   801016c0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105136:	83 c4 10             	add    $0x10,%esp
80105139:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010513e:	74 30                	je     80105170 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105140:	83 ec 04             	sub    $0x4,%esp
80105143:	ff 76 04             	pushl  0x4(%esi)
80105146:	57                   	push   %edi
80105147:	53                   	push   %ebx
80105148:	e8 43 ce ff ff       	call   80101f90 <dirlink>
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	85 c0                	test   %eax,%eax
80105152:	78 78                	js     801051cc <create+0x17c>
  iunlockput(dp);
80105154:	83 ec 0c             	sub    $0xc,%esp
80105157:	53                   	push   %ebx
80105158:	e8 c3 c8 ff ff       	call   80101a20 <iunlockput>
  return ip;
8010515d:	83 c4 10             	add    $0x10,%esp
}
80105160:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105163:	89 f0                	mov    %esi,%eax
80105165:	5b                   	pop    %ebx
80105166:	5e                   	pop    %esi
80105167:	5f                   	pop    %edi
80105168:	5d                   	pop    %ebp
80105169:	c3                   	ret    
8010516a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105170:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105173:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105178:	53                   	push   %ebx
80105179:	e8 42 c5 ff ff       	call   801016c0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010517e:	83 c4 0c             	add    $0xc,%esp
80105181:	ff 76 04             	pushl  0x4(%esi)
80105184:	68 64 7e 10 80       	push   $0x80107e64
80105189:	56                   	push   %esi
8010518a:	e8 01 ce ff ff       	call   80101f90 <dirlink>
8010518f:	83 c4 10             	add    $0x10,%esp
80105192:	85 c0                	test   %eax,%eax
80105194:	78 18                	js     801051ae <create+0x15e>
80105196:	83 ec 04             	sub    $0x4,%esp
80105199:	ff 73 04             	pushl  0x4(%ebx)
8010519c:	68 63 7e 10 80       	push   $0x80107e63
801051a1:	56                   	push   %esi
801051a2:	e8 e9 cd ff ff       	call   80101f90 <dirlink>
801051a7:	83 c4 10             	add    $0x10,%esp
801051aa:	85 c0                	test   %eax,%eax
801051ac:	79 92                	jns    80105140 <create+0xf0>
      panic("create dots");
801051ae:	83 ec 0c             	sub    $0xc,%esp
801051b1:	68 57 7e 10 80       	push   $0x80107e57
801051b6:	e8 d5 b1 ff ff       	call   80100390 <panic>
801051bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051bf:	90                   	nop
}
801051c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801051c3:	31 f6                	xor    %esi,%esi
}
801051c5:	5b                   	pop    %ebx
801051c6:	89 f0                	mov    %esi,%eax
801051c8:	5e                   	pop    %esi
801051c9:	5f                   	pop    %edi
801051ca:	5d                   	pop    %ebp
801051cb:	c3                   	ret    
    panic("create: dirlink");
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	68 66 7e 10 80       	push   $0x80107e66
801051d4:	e8 b7 b1 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801051d9:	83 ec 0c             	sub    $0xc,%esp
801051dc:	68 48 7e 10 80       	push   $0x80107e48
801051e1:	e8 aa b1 ff ff       	call   80100390 <panic>
801051e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ed:	8d 76 00             	lea    0x0(%esi),%esi

801051f0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	56                   	push   %esi
801051f4:	89 d6                	mov    %edx,%esi
801051f6:	53                   	push   %ebx
801051f7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801051f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801051fc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051ff:	50                   	push   %eax
80105200:	6a 00                	push   $0x0
80105202:	e8 c9 fc ff ff       	call   80104ed0 <argint>
80105207:	83 c4 10             	add    $0x10,%esp
8010520a:	85 c0                	test   %eax,%eax
8010520c:	78 2a                	js     80105238 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010520e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105212:	77 24                	ja     80105238 <argfd.constprop.0+0x48>
80105214:	e8 97 e7 ff ff       	call   801039b0 <myproc>
80105219:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010521c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105220:	85 c0                	test   %eax,%eax
80105222:	74 14                	je     80105238 <argfd.constprop.0+0x48>
  if(pfd)
80105224:	85 db                	test   %ebx,%ebx
80105226:	74 02                	je     8010522a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105228:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010522a:	89 06                	mov    %eax,(%esi)
  return 0;
8010522c:	31 c0                	xor    %eax,%eax
}
8010522e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105231:	5b                   	pop    %ebx
80105232:	5e                   	pop    %esi
80105233:	5d                   	pop    %ebp
80105234:	c3                   	ret    
80105235:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010523d:	eb ef                	jmp    8010522e <argfd.constprop.0+0x3e>
8010523f:	90                   	nop

80105240 <sys_dup>:
{
80105240:	f3 0f 1e fb          	endbr32 
80105244:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105245:	31 c0                	xor    %eax,%eax
{
80105247:	89 e5                	mov    %esp,%ebp
80105249:	56                   	push   %esi
8010524a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010524b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010524e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105251:	e8 9a ff ff ff       	call   801051f0 <argfd.constprop.0>
80105256:	85 c0                	test   %eax,%eax
80105258:	78 1e                	js     80105278 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010525a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010525d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010525f:	e8 4c e7 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105268:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010526c:	85 d2                	test   %edx,%edx
8010526e:	74 20                	je     80105290 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105270:	83 c3 01             	add    $0x1,%ebx
80105273:	83 fb 10             	cmp    $0x10,%ebx
80105276:	75 f0                	jne    80105268 <sys_dup+0x28>
}
80105278:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010527b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105280:	89 d8                	mov    %ebx,%eax
80105282:	5b                   	pop    %ebx
80105283:	5e                   	pop    %esi
80105284:	5d                   	pop    %ebp
80105285:	c3                   	ret    
80105286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105290:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	ff 75 f4             	pushl  -0xc(%ebp)
8010529a:	e8 f1 bb ff ff       	call   80100e90 <filedup>
  return fd;
8010529f:	83 c4 10             	add    $0x10,%esp
}
801052a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052a5:	89 d8                	mov    %ebx,%eax
801052a7:	5b                   	pop    %ebx
801052a8:	5e                   	pop    %esi
801052a9:	5d                   	pop    %ebp
801052aa:	c3                   	ret    
801052ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052af:	90                   	nop

801052b0 <sys_read>:
{
801052b0:	f3 0f 1e fb          	endbr32 
801052b4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052b5:	31 c0                	xor    %eax,%eax
{
801052b7:	89 e5                	mov    %esp,%ebp
801052b9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052bc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801052bf:	e8 2c ff ff ff       	call   801051f0 <argfd.constprop.0>
801052c4:	85 c0                	test   %eax,%eax
801052c6:	78 48                	js     80105310 <sys_read+0x60>
801052c8:	83 ec 08             	sub    $0x8,%esp
801052cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052ce:	50                   	push   %eax
801052cf:	6a 02                	push   $0x2
801052d1:	e8 fa fb ff ff       	call   80104ed0 <argint>
801052d6:	83 c4 10             	add    $0x10,%esp
801052d9:	85 c0                	test   %eax,%eax
801052db:	78 33                	js     80105310 <sys_read+0x60>
801052dd:	83 ec 04             	sub    $0x4,%esp
801052e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052e3:	ff 75 f0             	pushl  -0x10(%ebp)
801052e6:	50                   	push   %eax
801052e7:	6a 01                	push   $0x1
801052e9:	e8 32 fc ff ff       	call   80104f20 <argptr>
801052ee:	83 c4 10             	add    $0x10,%esp
801052f1:	85 c0                	test   %eax,%eax
801052f3:	78 1b                	js     80105310 <sys_read+0x60>
  return fileread(f, p, n);
801052f5:	83 ec 04             	sub    $0x4,%esp
801052f8:	ff 75 f0             	pushl  -0x10(%ebp)
801052fb:	ff 75 f4             	pushl  -0xc(%ebp)
801052fe:	ff 75 ec             	pushl  -0x14(%ebp)
80105301:	e8 0a bd ff ff       	call   80101010 <fileread>
80105306:	83 c4 10             	add    $0x10,%esp
}
80105309:	c9                   	leave  
8010530a:	c3                   	ret    
8010530b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010530f:	90                   	nop
80105310:	c9                   	leave  
    return -1;
80105311:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105316:	c3                   	ret    
80105317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531e:	66 90                	xchg   %ax,%ax

80105320 <sys_write>:
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105325:	31 c0                	xor    %eax,%eax
{
80105327:	89 e5                	mov    %esp,%ebp
80105329:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010532c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010532f:	e8 bc fe ff ff       	call   801051f0 <argfd.constprop.0>
80105334:	85 c0                	test   %eax,%eax
80105336:	78 48                	js     80105380 <sys_write+0x60>
80105338:	83 ec 08             	sub    $0x8,%esp
8010533b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010533e:	50                   	push   %eax
8010533f:	6a 02                	push   $0x2
80105341:	e8 8a fb ff ff       	call   80104ed0 <argint>
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	85 c0                	test   %eax,%eax
8010534b:	78 33                	js     80105380 <sys_write+0x60>
8010534d:	83 ec 04             	sub    $0x4,%esp
80105350:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105353:	ff 75 f0             	pushl  -0x10(%ebp)
80105356:	50                   	push   %eax
80105357:	6a 01                	push   $0x1
80105359:	e8 c2 fb ff ff       	call   80104f20 <argptr>
8010535e:	83 c4 10             	add    $0x10,%esp
80105361:	85 c0                	test   %eax,%eax
80105363:	78 1b                	js     80105380 <sys_write+0x60>
  return filewrite(f, p, n);
80105365:	83 ec 04             	sub    $0x4,%esp
80105368:	ff 75 f0             	pushl  -0x10(%ebp)
8010536b:	ff 75 f4             	pushl  -0xc(%ebp)
8010536e:	ff 75 ec             	pushl  -0x14(%ebp)
80105371:	e8 3a bd ff ff       	call   801010b0 <filewrite>
80105376:	83 c4 10             	add    $0x10,%esp
}
80105379:	c9                   	leave  
8010537a:	c3                   	ret    
8010537b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010537f:	90                   	nop
80105380:	c9                   	leave  
    return -1;
80105381:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105386:	c3                   	ret    
80105387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538e:	66 90                	xchg   %ax,%ax

80105390 <sys_close>:
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010539a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010539d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053a0:	e8 4b fe ff ff       	call   801051f0 <argfd.constprop.0>
801053a5:	85 c0                	test   %eax,%eax
801053a7:	78 27                	js     801053d0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801053a9:	e8 02 e6 ff ff       	call   801039b0 <myproc>
801053ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801053b1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801053b4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801053bb:	00 
  fileclose(f);
801053bc:	ff 75 f4             	pushl  -0xc(%ebp)
801053bf:	e8 1c bb ff ff       	call   80100ee0 <fileclose>
  return 0;
801053c4:	83 c4 10             	add    $0x10,%esp
801053c7:	31 c0                	xor    %eax,%eax
}
801053c9:	c9                   	leave  
801053ca:	c3                   	ret    
801053cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053cf:	90                   	nop
801053d0:	c9                   	leave  
    return -1;
801053d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053d6:	c3                   	ret    
801053d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053de:	66 90                	xchg   %ax,%ax

801053e0 <sys_fstat>:
{
801053e0:	f3 0f 1e fb          	endbr32 
801053e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053e5:	31 c0                	xor    %eax,%eax
{
801053e7:	89 e5                	mov    %esp,%ebp
801053e9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801053ec:	8d 55 f0             	lea    -0x10(%ebp),%edx
801053ef:	e8 fc fd ff ff       	call   801051f0 <argfd.constprop.0>
801053f4:	85 c0                	test   %eax,%eax
801053f6:	78 30                	js     80105428 <sys_fstat+0x48>
801053f8:	83 ec 04             	sub    $0x4,%esp
801053fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053fe:	6a 14                	push   $0x14
80105400:	50                   	push   %eax
80105401:	6a 01                	push   $0x1
80105403:	e8 18 fb ff ff       	call   80104f20 <argptr>
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	85 c0                	test   %eax,%eax
8010540d:	78 19                	js     80105428 <sys_fstat+0x48>
  return filestat(f, st);
8010540f:	83 ec 08             	sub    $0x8,%esp
80105412:	ff 75 f4             	pushl  -0xc(%ebp)
80105415:	ff 75 f0             	pushl  -0x10(%ebp)
80105418:	e8 a3 bb ff ff       	call   80100fc0 <filestat>
8010541d:	83 c4 10             	add    $0x10,%esp
}
80105420:	c9                   	leave  
80105421:	c3                   	ret    
80105422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105428:	c9                   	leave  
    return -1;
80105429:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010542e:	c3                   	ret    
8010542f:	90                   	nop

80105430 <sys_link>:
{
80105430:	f3 0f 1e fb          	endbr32 
80105434:	55                   	push   %ebp
80105435:	89 e5                	mov    %esp,%ebp
80105437:	57                   	push   %edi
80105438:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105439:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010543c:	53                   	push   %ebx
8010543d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105440:	50                   	push   %eax
80105441:	6a 00                	push   $0x0
80105443:	e8 38 fb ff ff       	call   80104f80 <argstr>
80105448:	83 c4 10             	add    $0x10,%esp
8010544b:	85 c0                	test   %eax,%eax
8010544d:	0f 88 ff 00 00 00    	js     80105552 <sys_link+0x122>
80105453:	83 ec 08             	sub    $0x8,%esp
80105456:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105459:	50                   	push   %eax
8010545a:	6a 01                	push   $0x1
8010545c:	e8 1f fb ff ff       	call   80104f80 <argstr>
80105461:	83 c4 10             	add    $0x10,%esp
80105464:	85 c0                	test   %eax,%eax
80105466:	0f 88 e6 00 00 00    	js     80105552 <sys_link+0x122>
  begin_op();
8010546c:	e8 df d8 ff ff       	call   80102d50 <begin_op>
  if((ip = namei(old)) == 0){
80105471:	83 ec 0c             	sub    $0xc,%esp
80105474:	ff 75 d4             	pushl  -0x2c(%ebp)
80105477:	e8 d4 cb ff ff       	call   80102050 <namei>
8010547c:	83 c4 10             	add    $0x10,%esp
8010547f:	89 c3                	mov    %eax,%ebx
80105481:	85 c0                	test   %eax,%eax
80105483:	0f 84 e8 00 00 00    	je     80105571 <sys_link+0x141>
  ilock(ip);
80105489:	83 ec 0c             	sub    $0xc,%esp
8010548c:	50                   	push   %eax
8010548d:	e8 ee c2 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
80105492:	83 c4 10             	add    $0x10,%esp
80105495:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010549a:	0f 84 b9 00 00 00    	je     80105559 <sys_link+0x129>
  iupdate(ip);
801054a0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801054a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801054a8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801054ab:	53                   	push   %ebx
801054ac:	e8 0f c2 ff ff       	call   801016c0 <iupdate>
  iunlock(ip);
801054b1:	89 1c 24             	mov    %ebx,(%esp)
801054b4:	e8 a7 c3 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801054b9:	58                   	pop    %eax
801054ba:	5a                   	pop    %edx
801054bb:	57                   	push   %edi
801054bc:	ff 75 d0             	pushl  -0x30(%ebp)
801054bf:	e8 ac cb ff ff       	call   80102070 <nameiparent>
801054c4:	83 c4 10             	add    $0x10,%esp
801054c7:	89 c6                	mov    %eax,%esi
801054c9:	85 c0                	test   %eax,%eax
801054cb:	74 5f                	je     8010552c <sys_link+0xfc>
  ilock(dp);
801054cd:	83 ec 0c             	sub    $0xc,%esp
801054d0:	50                   	push   %eax
801054d1:	e8 aa c2 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801054d6:	8b 03                	mov    (%ebx),%eax
801054d8:	83 c4 10             	add    $0x10,%esp
801054db:	39 06                	cmp    %eax,(%esi)
801054dd:	75 41                	jne    80105520 <sys_link+0xf0>
801054df:	83 ec 04             	sub    $0x4,%esp
801054e2:	ff 73 04             	pushl  0x4(%ebx)
801054e5:	57                   	push   %edi
801054e6:	56                   	push   %esi
801054e7:	e8 a4 ca ff ff       	call   80101f90 <dirlink>
801054ec:	83 c4 10             	add    $0x10,%esp
801054ef:	85 c0                	test   %eax,%eax
801054f1:	78 2d                	js     80105520 <sys_link+0xf0>
  iunlockput(dp);
801054f3:	83 ec 0c             	sub    $0xc,%esp
801054f6:	56                   	push   %esi
801054f7:	e8 24 c5 ff ff       	call   80101a20 <iunlockput>
  iput(ip);
801054fc:	89 1c 24             	mov    %ebx,(%esp)
801054ff:	e8 ac c3 ff ff       	call   801018b0 <iput>
  end_op();
80105504:	e8 b7 d8 ff ff       	call   80102dc0 <end_op>
  return 0;
80105509:	83 c4 10             	add    $0x10,%esp
8010550c:	31 c0                	xor    %eax,%eax
}
8010550e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105511:	5b                   	pop    %ebx
80105512:	5e                   	pop    %esi
80105513:	5f                   	pop    %edi
80105514:	5d                   	pop    %ebp
80105515:	c3                   	ret    
80105516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	56                   	push   %esi
80105524:	e8 f7 c4 ff ff       	call   80101a20 <iunlockput>
    goto bad;
80105529:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010552c:	83 ec 0c             	sub    $0xc,%esp
8010552f:	53                   	push   %ebx
80105530:	e8 4b c2 ff ff       	call   80101780 <ilock>
  ip->nlink--;
80105535:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010553a:	89 1c 24             	mov    %ebx,(%esp)
8010553d:	e8 7e c1 ff ff       	call   801016c0 <iupdate>
  iunlockput(ip);
80105542:	89 1c 24             	mov    %ebx,(%esp)
80105545:	e8 d6 c4 ff ff       	call   80101a20 <iunlockput>
  end_op();
8010554a:	e8 71 d8 ff ff       	call   80102dc0 <end_op>
  return -1;
8010554f:	83 c4 10             	add    $0x10,%esp
80105552:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105557:	eb b5                	jmp    8010550e <sys_link+0xde>
    iunlockput(ip);
80105559:	83 ec 0c             	sub    $0xc,%esp
8010555c:	53                   	push   %ebx
8010555d:	e8 be c4 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105562:	e8 59 d8 ff ff       	call   80102dc0 <end_op>
    return -1;
80105567:	83 c4 10             	add    $0x10,%esp
8010556a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010556f:	eb 9d                	jmp    8010550e <sys_link+0xde>
    end_op();
80105571:	e8 4a d8 ff ff       	call   80102dc0 <end_op>
    return -1;
80105576:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557b:	eb 91                	jmp    8010550e <sys_link+0xde>
8010557d:	8d 76 00             	lea    0x0(%esi),%esi

80105580 <sys_unlink>:
{
80105580:	f3 0f 1e fb          	endbr32 
80105584:	55                   	push   %ebp
80105585:	89 e5                	mov    %esp,%ebp
80105587:	57                   	push   %edi
80105588:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105589:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010558c:	53                   	push   %ebx
8010558d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105590:	50                   	push   %eax
80105591:	6a 00                	push   $0x0
80105593:	e8 e8 f9 ff ff       	call   80104f80 <argstr>
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	85 c0                	test   %eax,%eax
8010559d:	0f 88 7d 01 00 00    	js     80105720 <sys_unlink+0x1a0>
  begin_op();
801055a3:	e8 a8 d7 ff ff       	call   80102d50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801055a8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801055ab:	83 ec 08             	sub    $0x8,%esp
801055ae:	53                   	push   %ebx
801055af:	ff 75 c0             	pushl  -0x40(%ebp)
801055b2:	e8 b9 ca ff ff       	call   80102070 <nameiparent>
801055b7:	83 c4 10             	add    $0x10,%esp
801055ba:	89 c6                	mov    %eax,%esi
801055bc:	85 c0                	test   %eax,%eax
801055be:	0f 84 66 01 00 00    	je     8010572a <sys_unlink+0x1aa>
  ilock(dp);
801055c4:	83 ec 0c             	sub    $0xc,%esp
801055c7:	50                   	push   %eax
801055c8:	e8 b3 c1 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801055cd:	58                   	pop    %eax
801055ce:	5a                   	pop    %edx
801055cf:	68 64 7e 10 80       	push   $0x80107e64
801055d4:	53                   	push   %ebx
801055d5:	e8 d6 c6 ff ff       	call   80101cb0 <namecmp>
801055da:	83 c4 10             	add    $0x10,%esp
801055dd:	85 c0                	test   %eax,%eax
801055df:	0f 84 03 01 00 00    	je     801056e8 <sys_unlink+0x168>
801055e5:	83 ec 08             	sub    $0x8,%esp
801055e8:	68 63 7e 10 80       	push   $0x80107e63
801055ed:	53                   	push   %ebx
801055ee:	e8 bd c6 ff ff       	call   80101cb0 <namecmp>
801055f3:	83 c4 10             	add    $0x10,%esp
801055f6:	85 c0                	test   %eax,%eax
801055f8:	0f 84 ea 00 00 00    	je     801056e8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801055fe:	83 ec 04             	sub    $0x4,%esp
80105601:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105604:	50                   	push   %eax
80105605:	53                   	push   %ebx
80105606:	56                   	push   %esi
80105607:	e8 c4 c6 ff ff       	call   80101cd0 <dirlookup>
8010560c:	83 c4 10             	add    $0x10,%esp
8010560f:	89 c3                	mov    %eax,%ebx
80105611:	85 c0                	test   %eax,%eax
80105613:	0f 84 cf 00 00 00    	je     801056e8 <sys_unlink+0x168>
  ilock(ip);
80105619:	83 ec 0c             	sub    $0xc,%esp
8010561c:	50                   	push   %eax
8010561d:	e8 5e c1 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010562a:	0f 8e 23 01 00 00    	jle    80105753 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105630:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105635:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105638:	74 66                	je     801056a0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010563a:	83 ec 04             	sub    $0x4,%esp
8010563d:	6a 10                	push   $0x10
8010563f:	6a 00                	push   $0x0
80105641:	57                   	push   %edi
80105642:	e8 a9 f5 ff ff       	call   80104bf0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105647:	6a 10                	push   $0x10
80105649:	ff 75 c4             	pushl  -0x3c(%ebp)
8010564c:	57                   	push   %edi
8010564d:	56                   	push   %esi
8010564e:	e8 2d c5 ff ff       	call   80101b80 <writei>
80105653:	83 c4 20             	add    $0x20,%esp
80105656:	83 f8 10             	cmp    $0x10,%eax
80105659:	0f 85 e7 00 00 00    	jne    80105746 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010565f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105664:	0f 84 96 00 00 00    	je     80105700 <sys_unlink+0x180>
  iunlockput(dp);
8010566a:	83 ec 0c             	sub    $0xc,%esp
8010566d:	56                   	push   %esi
8010566e:	e8 ad c3 ff ff       	call   80101a20 <iunlockput>
  ip->nlink--;
80105673:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105678:	89 1c 24             	mov    %ebx,(%esp)
8010567b:	e8 40 c0 ff ff       	call   801016c0 <iupdate>
  iunlockput(ip);
80105680:	89 1c 24             	mov    %ebx,(%esp)
80105683:	e8 98 c3 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105688:	e8 33 d7 ff ff       	call   80102dc0 <end_op>
  return 0;
8010568d:	83 c4 10             	add    $0x10,%esp
80105690:	31 c0                	xor    %eax,%eax
}
80105692:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105695:	5b                   	pop    %ebx
80105696:	5e                   	pop    %esi
80105697:	5f                   	pop    %edi
80105698:	5d                   	pop    %ebp
80105699:	c3                   	ret    
8010569a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801056a0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801056a4:	76 94                	jbe    8010563a <sys_unlink+0xba>
801056a6:	ba 20 00 00 00       	mov    $0x20,%edx
801056ab:	eb 0b                	jmp    801056b8 <sys_unlink+0x138>
801056ad:	8d 76 00             	lea    0x0(%esi),%esi
801056b0:	83 c2 10             	add    $0x10,%edx
801056b3:	39 53 58             	cmp    %edx,0x58(%ebx)
801056b6:	76 82                	jbe    8010563a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801056b8:	6a 10                	push   $0x10
801056ba:	52                   	push   %edx
801056bb:	57                   	push   %edi
801056bc:	53                   	push   %ebx
801056bd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801056c0:	e8 bb c3 ff ff       	call   80101a80 <readi>
801056c5:	83 c4 10             	add    $0x10,%esp
801056c8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801056cb:	83 f8 10             	cmp    $0x10,%eax
801056ce:	75 69                	jne    80105739 <sys_unlink+0x1b9>
    if(de.inum != 0)
801056d0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801056d5:	74 d9                	je     801056b0 <sys_unlink+0x130>
    iunlockput(ip);
801056d7:	83 ec 0c             	sub    $0xc,%esp
801056da:	53                   	push   %ebx
801056db:	e8 40 c3 ff ff       	call   80101a20 <iunlockput>
    goto bad;
801056e0:	83 c4 10             	add    $0x10,%esp
801056e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056e7:	90                   	nop
  iunlockput(dp);
801056e8:	83 ec 0c             	sub    $0xc,%esp
801056eb:	56                   	push   %esi
801056ec:	e8 2f c3 ff ff       	call   80101a20 <iunlockput>
  end_op();
801056f1:	e8 ca d6 ff ff       	call   80102dc0 <end_op>
  return -1;
801056f6:	83 c4 10             	add    $0x10,%esp
801056f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056fe:	eb 92                	jmp    80105692 <sys_unlink+0x112>
    iupdate(dp);
80105700:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105703:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105708:	56                   	push   %esi
80105709:	e8 b2 bf ff ff       	call   801016c0 <iupdate>
8010570e:	83 c4 10             	add    $0x10,%esp
80105711:	e9 54 ff ff ff       	jmp    8010566a <sys_unlink+0xea>
80105716:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105725:	e9 68 ff ff ff       	jmp    80105692 <sys_unlink+0x112>
    end_op();
8010572a:	e8 91 d6 ff ff       	call   80102dc0 <end_op>
    return -1;
8010572f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105734:	e9 59 ff ff ff       	jmp    80105692 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105739:	83 ec 0c             	sub    $0xc,%esp
8010573c:	68 88 7e 10 80       	push   $0x80107e88
80105741:	e8 4a ac ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105746:	83 ec 0c             	sub    $0xc,%esp
80105749:	68 9a 7e 10 80       	push   $0x80107e9a
8010574e:	e8 3d ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105753:	83 ec 0c             	sub    $0xc,%esp
80105756:	68 76 7e 10 80       	push   $0x80107e76
8010575b:	e8 30 ac ff ff       	call   80100390 <panic>

80105760 <sys_open>:

int
sys_open(void)
{
80105760:	f3 0f 1e fb          	endbr32 
80105764:	55                   	push   %ebp
80105765:	89 e5                	mov    %esp,%ebp
80105767:	57                   	push   %edi
80105768:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105769:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010576c:	53                   	push   %ebx
8010576d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105770:	50                   	push   %eax
80105771:	6a 00                	push   $0x0
80105773:	e8 08 f8 ff ff       	call   80104f80 <argstr>
80105778:	83 c4 10             	add    $0x10,%esp
8010577b:	85 c0                	test   %eax,%eax
8010577d:	0f 88 8a 00 00 00    	js     8010580d <sys_open+0xad>
80105783:	83 ec 08             	sub    $0x8,%esp
80105786:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105789:	50                   	push   %eax
8010578a:	6a 01                	push   $0x1
8010578c:	e8 3f f7 ff ff       	call   80104ed0 <argint>
80105791:	83 c4 10             	add    $0x10,%esp
80105794:	85 c0                	test   %eax,%eax
80105796:	78 75                	js     8010580d <sys_open+0xad>
    return -1;

  begin_op();
80105798:	e8 b3 d5 ff ff       	call   80102d50 <begin_op>

  if(omode & O_CREATE){
8010579d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801057a1:	75 75                	jne    80105818 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801057a3:	83 ec 0c             	sub    $0xc,%esp
801057a6:	ff 75 e0             	pushl  -0x20(%ebp)
801057a9:	e8 a2 c8 ff ff       	call   80102050 <namei>
801057ae:	83 c4 10             	add    $0x10,%esp
801057b1:	89 c6                	mov    %eax,%esi
801057b3:	85 c0                	test   %eax,%eax
801057b5:	74 7e                	je     80105835 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801057b7:	83 ec 0c             	sub    $0xc,%esp
801057ba:	50                   	push   %eax
801057bb:	e8 c0 bf ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801057c0:	83 c4 10             	add    $0x10,%esp
801057c3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801057c8:	0f 84 c2 00 00 00    	je     80105890 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801057ce:	e8 4d b6 ff ff       	call   80100e20 <filealloc>
801057d3:	89 c7                	mov    %eax,%edi
801057d5:	85 c0                	test   %eax,%eax
801057d7:	74 23                	je     801057fc <sys_open+0x9c>
  struct proc *curproc = myproc();
801057d9:	e8 d2 e1 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057de:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801057e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057e4:	85 d2                	test   %edx,%edx
801057e6:	74 60                	je     80105848 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801057e8:	83 c3 01             	add    $0x1,%ebx
801057eb:	83 fb 10             	cmp    $0x10,%ebx
801057ee:	75 f0                	jne    801057e0 <sys_open+0x80>
    if(f)
      fileclose(f);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	57                   	push   %edi
801057f4:	e8 e7 b6 ff ff       	call   80100ee0 <fileclose>
801057f9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801057fc:	83 ec 0c             	sub    $0xc,%esp
801057ff:	56                   	push   %esi
80105800:	e8 1b c2 ff ff       	call   80101a20 <iunlockput>
    end_op();
80105805:	e8 b6 d5 ff ff       	call   80102dc0 <end_op>
    return -1;
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105812:	eb 6d                	jmp    80105881 <sys_open+0x121>
80105814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105818:	83 ec 0c             	sub    $0xc,%esp
8010581b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010581e:	31 c9                	xor    %ecx,%ecx
80105820:	ba 02 00 00 00       	mov    $0x2,%edx
80105825:	6a 00                	push   $0x0
80105827:	e8 24 f8 ff ff       	call   80105050 <create>
    if(ip == 0){
8010582c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010582f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105831:	85 c0                	test   %eax,%eax
80105833:	75 99                	jne    801057ce <sys_open+0x6e>
      end_op();
80105835:	e8 86 d5 ff ff       	call   80102dc0 <end_op>
      return -1;
8010583a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010583f:	eb 40                	jmp    80105881 <sys_open+0x121>
80105841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105848:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010584b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010584f:	56                   	push   %esi
80105850:	e8 0b c0 ff ff       	call   80101860 <iunlock>
  end_op();
80105855:	e8 66 d5 ff ff       	call   80102dc0 <end_op>

  f->type = FD_INODE;
8010585a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105860:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105863:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105866:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105869:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010586b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105872:	f7 d0                	not    %eax
80105874:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105877:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010587a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010587d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105881:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105884:	89 d8                	mov    %ebx,%eax
80105886:	5b                   	pop    %ebx
80105887:	5e                   	pop    %esi
80105888:	5f                   	pop    %edi
80105889:	5d                   	pop    %ebp
8010588a:	c3                   	ret    
8010588b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010588f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105890:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105893:	85 c9                	test   %ecx,%ecx
80105895:	0f 84 33 ff ff ff    	je     801057ce <sys_open+0x6e>
8010589b:	e9 5c ff ff ff       	jmp    801057fc <sys_open+0x9c>

801058a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801058aa:	e8 a1 d4 ff ff       	call   80102d50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801058af:	83 ec 08             	sub    $0x8,%esp
801058b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058b5:	50                   	push   %eax
801058b6:	6a 00                	push   $0x0
801058b8:	e8 c3 f6 ff ff       	call   80104f80 <argstr>
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	85 c0                	test   %eax,%eax
801058c2:	78 34                	js     801058f8 <sys_mkdir+0x58>
801058c4:	83 ec 0c             	sub    $0xc,%esp
801058c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ca:	31 c9                	xor    %ecx,%ecx
801058cc:	ba 01 00 00 00       	mov    $0x1,%edx
801058d1:	6a 00                	push   $0x0
801058d3:	e8 78 f7 ff ff       	call   80105050 <create>
801058d8:	83 c4 10             	add    $0x10,%esp
801058db:	85 c0                	test   %eax,%eax
801058dd:	74 19                	je     801058f8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801058df:	83 ec 0c             	sub    $0xc,%esp
801058e2:	50                   	push   %eax
801058e3:	e8 38 c1 ff ff       	call   80101a20 <iunlockput>
  end_op();
801058e8:	e8 d3 d4 ff ff       	call   80102dc0 <end_op>
  return 0;
801058ed:	83 c4 10             	add    $0x10,%esp
801058f0:	31 c0                	xor    %eax,%eax
}
801058f2:	c9                   	leave  
801058f3:	c3                   	ret    
801058f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801058f8:	e8 c3 d4 ff ff       	call   80102dc0 <end_op>
    return -1;
801058fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105902:	c9                   	leave  
80105903:	c3                   	ret    
80105904:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010590f:	90                   	nop

80105910 <sys_mknod>:

int
sys_mknod(void)
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010591a:	e8 31 d4 ff ff       	call   80102d50 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010591f:	83 ec 08             	sub    $0x8,%esp
80105922:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105925:	50                   	push   %eax
80105926:	6a 00                	push   $0x0
80105928:	e8 53 f6 ff ff       	call   80104f80 <argstr>
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	85 c0                	test   %eax,%eax
80105932:	78 64                	js     80105998 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105934:	83 ec 08             	sub    $0x8,%esp
80105937:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010593a:	50                   	push   %eax
8010593b:	6a 01                	push   $0x1
8010593d:	e8 8e f5 ff ff       	call   80104ed0 <argint>
  if((argstr(0, &path)) < 0 ||
80105942:	83 c4 10             	add    $0x10,%esp
80105945:	85 c0                	test   %eax,%eax
80105947:	78 4f                	js     80105998 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105949:	83 ec 08             	sub    $0x8,%esp
8010594c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010594f:	50                   	push   %eax
80105950:	6a 02                	push   $0x2
80105952:	e8 79 f5 ff ff       	call   80104ed0 <argint>
     argint(1, &major) < 0 ||
80105957:	83 c4 10             	add    $0x10,%esp
8010595a:	85 c0                	test   %eax,%eax
8010595c:	78 3a                	js     80105998 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010595e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105962:	83 ec 0c             	sub    $0xc,%esp
80105965:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105969:	ba 03 00 00 00       	mov    $0x3,%edx
8010596e:	50                   	push   %eax
8010596f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105972:	e8 d9 f6 ff ff       	call   80105050 <create>
     argint(2, &minor) < 0 ||
80105977:	83 c4 10             	add    $0x10,%esp
8010597a:	85 c0                	test   %eax,%eax
8010597c:	74 1a                	je     80105998 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010597e:	83 ec 0c             	sub    $0xc,%esp
80105981:	50                   	push   %eax
80105982:	e8 99 c0 ff ff       	call   80101a20 <iunlockput>
  end_op();
80105987:	e8 34 d4 ff ff       	call   80102dc0 <end_op>
  return 0;
8010598c:	83 c4 10             	add    $0x10,%esp
8010598f:	31 c0                	xor    %eax,%eax
}
80105991:	c9                   	leave  
80105992:	c3                   	ret    
80105993:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105997:	90                   	nop
    end_op();
80105998:	e8 23 d4 ff ff       	call   80102dc0 <end_op>
    return -1;
8010599d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059a2:	c9                   	leave  
801059a3:	c3                   	ret    
801059a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059af:	90                   	nop

801059b0 <sys_chdir>:

int
sys_chdir(void)
{
801059b0:	f3 0f 1e fb          	endbr32 
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	56                   	push   %esi
801059b8:	53                   	push   %ebx
801059b9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801059bc:	e8 ef df ff ff       	call   801039b0 <myproc>
801059c1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801059c3:	e8 88 d3 ff ff       	call   80102d50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801059c8:	83 ec 08             	sub    $0x8,%esp
801059cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ce:	50                   	push   %eax
801059cf:	6a 00                	push   $0x0
801059d1:	e8 aa f5 ff ff       	call   80104f80 <argstr>
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	85 c0                	test   %eax,%eax
801059db:	78 73                	js     80105a50 <sys_chdir+0xa0>
801059dd:	83 ec 0c             	sub    $0xc,%esp
801059e0:	ff 75 f4             	pushl  -0xc(%ebp)
801059e3:	e8 68 c6 ff ff       	call   80102050 <namei>
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	89 c3                	mov    %eax,%ebx
801059ed:	85 c0                	test   %eax,%eax
801059ef:	74 5f                	je     80105a50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801059f1:	83 ec 0c             	sub    $0xc,%esp
801059f4:	50                   	push   %eax
801059f5:	e8 86 bd ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
801059fa:	83 c4 10             	add    $0x10,%esp
801059fd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a02:	75 2c                	jne    80105a30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105a04:	83 ec 0c             	sub    $0xc,%esp
80105a07:	53                   	push   %ebx
80105a08:	e8 53 be ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105a0d:	58                   	pop    %eax
80105a0e:	ff 76 68             	pushl  0x68(%esi)
80105a11:	e8 9a be ff ff       	call   801018b0 <iput>
  end_op();
80105a16:	e8 a5 d3 ff ff       	call   80102dc0 <end_op>
  curproc->cwd = ip;
80105a1b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	31 c0                	xor    %eax,%eax
}
80105a23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105a26:	5b                   	pop    %ebx
80105a27:	5e                   	pop    %esi
80105a28:	5d                   	pop    %ebp
80105a29:	c3                   	ret    
80105a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105a30:	83 ec 0c             	sub    $0xc,%esp
80105a33:	53                   	push   %ebx
80105a34:	e8 e7 bf ff ff       	call   80101a20 <iunlockput>
    end_op();
80105a39:	e8 82 d3 ff ff       	call   80102dc0 <end_op>
    return -1;
80105a3e:	83 c4 10             	add    $0x10,%esp
80105a41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a46:	eb db                	jmp    80105a23 <sys_chdir+0x73>
80105a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4f:	90                   	nop
    end_op();
80105a50:	e8 6b d3 ff ff       	call   80102dc0 <end_op>
    return -1;
80105a55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a5a:	eb c7                	jmp    80105a23 <sys_chdir+0x73>
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_exec>:

int
sys_exec(void)
{
80105a60:	f3 0f 1e fb          	endbr32 
80105a64:	55                   	push   %ebp
80105a65:	89 e5                	mov    %esp,%ebp
80105a67:	57                   	push   %edi
80105a68:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a69:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105a6f:	53                   	push   %ebx
80105a70:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105a76:	50                   	push   %eax
80105a77:	6a 00                	push   $0x0
80105a79:	e8 02 f5 ff ff       	call   80104f80 <argstr>
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	0f 88 8b 00 00 00    	js     80105b14 <sys_exec+0xb4>
80105a89:	83 ec 08             	sub    $0x8,%esp
80105a8c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105a92:	50                   	push   %eax
80105a93:	6a 01                	push   $0x1
80105a95:	e8 36 f4 ff ff       	call   80104ed0 <argint>
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	85 c0                	test   %eax,%eax
80105a9f:	78 73                	js     80105b14 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105aa1:	83 ec 04             	sub    $0x4,%esp
80105aa4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105aaa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105aac:	68 80 00 00 00       	push   $0x80
80105ab1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105ab7:	6a 00                	push   $0x0
80105ab9:	50                   	push   %eax
80105aba:	e8 31 f1 ff ff       	call   80104bf0 <memset>
80105abf:	83 c4 10             	add    $0x10,%esp
80105ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105ac8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105ace:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105ad5:	83 ec 08             	sub    $0x8,%esp
80105ad8:	57                   	push   %edi
80105ad9:	01 f0                	add    %esi,%eax
80105adb:	50                   	push   %eax
80105adc:	e8 4f f3 ff ff       	call   80104e30 <fetchint>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	78 2c                	js     80105b14 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105ae8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105aee:	85 c0                	test   %eax,%eax
80105af0:	74 36                	je     80105b28 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105af2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105af8:	83 ec 08             	sub    $0x8,%esp
80105afb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105afe:	52                   	push   %edx
80105aff:	50                   	push   %eax
80105b00:	e8 6b f3 ff ff       	call   80104e70 <fetchstr>
80105b05:	83 c4 10             	add    $0x10,%esp
80105b08:	85 c0                	test   %eax,%eax
80105b0a:	78 08                	js     80105b14 <sys_exec+0xb4>
  for(i=0;; i++){
80105b0c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105b0f:	83 fb 20             	cmp    $0x20,%ebx
80105b12:	75 b4                	jne    80105ac8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105b14:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105b17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b1c:	5b                   	pop    %ebx
80105b1d:	5e                   	pop    %esi
80105b1e:	5f                   	pop    %edi
80105b1f:	5d                   	pop    %ebp
80105b20:	c3                   	ret    
80105b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105b28:	83 ec 08             	sub    $0x8,%esp
80105b2b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105b31:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105b38:	00 00 00 00 
  return exec(path, argv);
80105b3c:	50                   	push   %eax
80105b3d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105b43:	e8 38 af ff ff       	call   80100a80 <exec>
80105b48:	83 c4 10             	add    $0x10,%esp
}
80105b4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b4e:	5b                   	pop    %ebx
80105b4f:	5e                   	pop    %esi
80105b50:	5f                   	pop    %edi
80105b51:	5d                   	pop    %ebp
80105b52:	c3                   	ret    
80105b53:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b60 <sys_pipe>:

int
sys_pipe(void)
{
80105b60:	f3 0f 1e fb          	endbr32 
80105b64:	55                   	push   %ebp
80105b65:	89 e5                	mov    %esp,%ebp
80105b67:	57                   	push   %edi
80105b68:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b69:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105b6c:	53                   	push   %ebx
80105b6d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105b70:	6a 08                	push   $0x8
80105b72:	50                   	push   %eax
80105b73:	6a 00                	push   $0x0
80105b75:	e8 a6 f3 ff ff       	call   80104f20 <argptr>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	78 4e                	js     80105bcf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105b81:	83 ec 08             	sub    $0x8,%esp
80105b84:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b87:	50                   	push   %eax
80105b88:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b8b:	50                   	push   %eax
80105b8c:	e8 7f d8 ff ff       	call   80103410 <pipealloc>
80105b91:	83 c4 10             	add    $0x10,%esp
80105b94:	85 c0                	test   %eax,%eax
80105b96:	78 37                	js     80105bcf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105b98:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105b9b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105b9d:	e8 0e de ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ba8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105bac:	85 f6                	test   %esi,%esi
80105bae:	74 30                	je     80105be0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105bb0:	83 c3 01             	add    $0x1,%ebx
80105bb3:	83 fb 10             	cmp    $0x10,%ebx
80105bb6:	75 f0                	jne    80105ba8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105bb8:	83 ec 0c             	sub    $0xc,%esp
80105bbb:	ff 75 e0             	pushl  -0x20(%ebp)
80105bbe:	e8 1d b3 ff ff       	call   80100ee0 <fileclose>
    fileclose(wf);
80105bc3:	58                   	pop    %eax
80105bc4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105bc7:	e8 14 b3 ff ff       	call   80100ee0 <fileclose>
    return -1;
80105bcc:	83 c4 10             	add    $0x10,%esp
80105bcf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd4:	eb 5b                	jmp    80105c31 <sys_pipe+0xd1>
80105bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105be0:	8d 73 08             	lea    0x8(%ebx),%esi
80105be3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105be7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105bea:	e8 c1 dd ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105bef:	31 d2                	xor    %edx,%edx
80105bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105bf8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105bfc:	85 c9                	test   %ecx,%ecx
80105bfe:	74 20                	je     80105c20 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105c00:	83 c2 01             	add    $0x1,%edx
80105c03:	83 fa 10             	cmp    $0x10,%edx
80105c06:	75 f0                	jne    80105bf8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105c08:	e8 a3 dd ff ff       	call   801039b0 <myproc>
80105c0d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105c14:	00 
80105c15:	eb a1                	jmp    80105bb8 <sys_pipe+0x58>
80105c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105c20:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105c24:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c27:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105c29:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105c2c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105c2f:	31 c0                	xor    %eax,%eax
}
80105c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c34:	5b                   	pop    %ebx
80105c35:	5e                   	pop    %esi
80105c36:	5f                   	pop    %edi
80105c37:	5d                   	pop    %ebp
80105c38:	c3                   	ret    
80105c39:	66 90                	xchg   %ax,%ax
80105c3b:	66 90                	xchg   %ax,%ax
80105c3d:	66 90                	xchg   %ax,%ax
80105c3f:	90                   	nop

80105c40 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105c40:	f3 0f 1e fb          	endbr32 
  return fork();
80105c44:	e9 27 e0 ff ff       	jmp    80103c70 <fork>
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c50 <sys_exit>:
}

int
sys_exit(void)
{
80105c50:	f3 0f 1e fb          	endbr32 
80105c54:	55                   	push   %ebp
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	83 ec 08             	sub    $0x8,%esp
  exit();
80105c5a:	e8 f1 e2 ff ff       	call   80103f50 <exit>
  return 0;  // not reached
}
80105c5f:	31 c0                	xor    %eax,%eax
80105c61:	c9                   	leave  
80105c62:	c3                   	ret    
80105c63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c70 <sys_wait>:

int
sys_wait(void)
{
80105c70:	f3 0f 1e fb          	endbr32 
  return wait();
80105c74:	e9 37 e5 ff ff       	jmp    801041b0 <wait>
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_kill>:
}

int
sys_kill(void)
{
80105c80:	f3 0f 1e fb          	endbr32 
80105c84:	55                   	push   %ebp
80105c85:	89 e5                	mov    %esp,%ebp
80105c87:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105c8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c8d:	50                   	push   %eax
80105c8e:	6a 00                	push   $0x0
80105c90:	e8 3b f2 ff ff       	call   80104ed0 <argint>
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	78 14                	js     80105cb0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105c9c:	83 ec 0c             	sub    $0xc,%esp
80105c9f:	ff 75 f4             	pushl  -0xc(%ebp)
80105ca2:	e8 d9 e6 ff ff       	call   80104380 <kill>
80105ca7:	83 c4 10             	add    $0x10,%esp
}
80105caa:	c9                   	leave  
80105cab:	c3                   	ret    
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cb0:	c9                   	leave  
    return -1;
80105cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cb6:	c3                   	ret    
80105cb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbe:	66 90                	xchg   %ax,%ax

80105cc0 <sys_getpid>:

int
sys_getpid(void)
{
80105cc0:	f3 0f 1e fb          	endbr32 
80105cc4:	55                   	push   %ebp
80105cc5:	89 e5                	mov    %esp,%ebp
80105cc7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105cca:	e8 e1 dc ff ff       	call   801039b0 <myproc>
80105ccf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105cd2:	c9                   	leave  
80105cd3:	c3                   	ret    
80105cd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cdf:	90                   	nop

80105ce0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ce0:	f3 0f 1e fb          	endbr32 
80105ce4:	55                   	push   %ebp
80105ce5:	89 e5                	mov    %esp,%ebp
80105ce7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ce8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ceb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105cee:	50                   	push   %eax
80105cef:	6a 00                	push   $0x0
80105cf1:	e8 da f1 ff ff       	call   80104ed0 <argint>
80105cf6:	83 c4 10             	add    $0x10,%esp
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	78 23                	js     80105d20 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105cfd:	e8 ae dc ff ff       	call   801039b0 <myproc>
  if(growproc(n) < 0)
80105d02:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105d05:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105d07:	ff 75 f4             	pushl  -0xc(%ebp)
80105d0a:	e8 d1 dd ff ff       	call   80103ae0 <growproc>
80105d0f:	83 c4 10             	add    $0x10,%esp
80105d12:	85 c0                	test   %eax,%eax
80105d14:	78 0a                	js     80105d20 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105d16:	89 d8                	mov    %ebx,%eax
80105d18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d1b:	c9                   	leave  
80105d1c:	c3                   	ret    
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105d20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d25:	eb ef                	jmp    80105d16 <sys_sbrk+0x36>
80105d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <sys_sleep>:

int
sys_sleep(void)
{
80105d30:	f3 0f 1e fb          	endbr32 
80105d34:	55                   	push   %ebp
80105d35:	89 e5                	mov    %esp,%ebp
80105d37:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105d3b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105d3e:	50                   	push   %eax
80105d3f:	6a 00                	push   $0x0
80105d41:	e8 8a f1 ff ff       	call   80104ed0 <argint>
80105d46:	83 c4 10             	add    $0x10,%esp
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	0f 88 86 00 00 00    	js     80105dd7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105d51:	83 ec 0c             	sub    $0xc,%esp
80105d54:	68 c0 5f 11 80       	push   $0x80115fc0
80105d59:	e8 82 ed ff ff       	call   80104ae0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105d61:	8b 1d 00 68 11 80    	mov    0x80116800,%ebx
  while(ticks - ticks0 < n){
80105d67:	83 c4 10             	add    $0x10,%esp
80105d6a:	85 d2                	test   %edx,%edx
80105d6c:	75 23                	jne    80105d91 <sys_sleep+0x61>
80105d6e:	eb 50                	jmp    80105dc0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105d70:	83 ec 08             	sub    $0x8,%esp
80105d73:	68 c0 5f 11 80       	push   $0x80115fc0
80105d78:	68 00 68 11 80       	push   $0x80116800
80105d7d:	e8 6e e3 ff ff       	call   801040f0 <sleep>
  while(ticks - ticks0 < n){
80105d82:	a1 00 68 11 80       	mov    0x80116800,%eax
80105d87:	83 c4 10             	add    $0x10,%esp
80105d8a:	29 d8                	sub    %ebx,%eax
80105d8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105d8f:	73 2f                	jae    80105dc0 <sys_sleep+0x90>
    if(myproc()->killed){
80105d91:	e8 1a dc ff ff       	call   801039b0 <myproc>
80105d96:	8b 40 24             	mov    0x24(%eax),%eax
80105d99:	85 c0                	test   %eax,%eax
80105d9b:	74 d3                	je     80105d70 <sys_sleep+0x40>
      release(&tickslock);
80105d9d:	83 ec 0c             	sub    $0xc,%esp
80105da0:	68 c0 5f 11 80       	push   $0x80115fc0
80105da5:	e8 f6 ed ff ff       	call   80104ba0 <release>
  }
  release(&tickslock);
  return 0;
}
80105daa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105db5:	c9                   	leave  
80105db6:	c3                   	ret    
80105db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dbe:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	68 c0 5f 11 80       	push   $0x80115fc0
80105dc8:	e8 d3 ed ff ff       	call   80104ba0 <release>
  return 0;
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	31 c0                	xor    %eax,%eax
}
80105dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105dd5:	c9                   	leave  
80105dd6:	c3                   	ret    
    return -1;
80105dd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ddc:	eb f4                	jmp    80105dd2 <sys_sleep+0xa2>
80105dde:	66 90                	xchg   %ax,%ax

80105de0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105de0:	f3 0f 1e fb          	endbr32 
80105de4:	55                   	push   %ebp
80105de5:	89 e5                	mov    %esp,%ebp
80105de7:	53                   	push   %ebx
80105de8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105deb:	68 c0 5f 11 80       	push   $0x80115fc0
80105df0:	e8 eb ec ff ff       	call   80104ae0 <acquire>
  xticks = ticks;
80105df5:	8b 1d 00 68 11 80    	mov    0x80116800,%ebx
  release(&tickslock);
80105dfb:	c7 04 24 c0 5f 11 80 	movl   $0x80115fc0,(%esp)
80105e02:	e8 99 ed ff ff       	call   80104ba0 <release>
  return xticks;
}
80105e07:	89 d8                	mov    %ebx,%eax
80105e09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e0c:	c9                   	leave  
80105e0d:	c3                   	ret    
80105e0e:	66 90                	xchg   %ax,%ax

80105e10 <sys_getProcCount>:

//return how many processes at the time
int
sys_getProcCount(void)
{
80105e10:	f3 0f 1e fb          	endbr32 
  return getProcCount();
80105e14:	e9 d7 e6 ff ff       	jmp    801044f0 <getProcCount>
80105e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e20 <sys_getReadCount>:
}

//return how many times the read system call have been called
int 
sys_getReadCount(void)
{
80105e20:	f3 0f 1e fb          	endbr32 
80105e24:	55                   	push   %ebp
80105e25:	89 e5                	mov    %esp,%ebp
80105e27:	83 ec 08             	sub    $0x8,%esp
  return myproc()->readid;
80105e2a:	e8 81 db ff ff       	call   801039b0 <myproc>
80105e2f:	8b 40 7c             	mov    0x7c(%eax),%eax
}
80105e32:	c9                   	leave  
80105e33:	c3                   	ret    
80105e34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e3f:	90                   	nop

80105e40 <sys_clone>:


int 
sys_clone(void)
{
80105e40:	f3 0f 1e fb          	endbr32 
80105e44:	55                   	push   %ebp
80105e45:	89 e5                	mov    %esp,%ebp
80105e47:	83 ec 20             	sub    $0x20,%esp
  int stackptr = 0;
  if(argint(0, &stackptr) < 0){
80105e4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  int stackptr = 0;
80105e4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(argint(0, &stackptr) < 0){
80105e54:	50                   	push   %eax
80105e55:	6a 00                	push   $0x0
80105e57:	e8 74 f0 ff ff       	call   80104ed0 <argint>
80105e5c:	83 c4 10             	add    $0x10,%esp
80105e5f:	85 c0                	test   %eax,%eax
80105e61:	78 15                	js     80105e78 <sys_clone+0x38>
    return -1;
  }
  else
    return clone((void*) stackptr);
80105e63:	83 ec 0c             	sub    $0xc,%esp
80105e66:	ff 75 f4             	pushl  -0xc(%ebp)
80105e69:	e8 d2 e6 ff ff       	call   80104540 <clone>
80105e6e:	83 c4 10             	add    $0x10,%esp
}
80105e71:	c9                   	leave  
80105e72:	c3                   	ret    
80105e73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e77:	90                   	nop
80105e78:	c9                   	leave  
    return -1;
80105e79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e7e:	c3                   	ret    
80105e7f:	90                   	nop

80105e80 <sys_join>:


int 
sys_join(void)
{
80105e80:	f3 0f 1e fb          	endbr32 
  return join();
80105e84:	e9 37 e8 ff ff       	jmp    801046c0 <join>

80105e89 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105e89:	1e                   	push   %ds
  pushl %es
80105e8a:	06                   	push   %es
  pushl %fs
80105e8b:	0f a0                	push   %fs
  pushl %gs
80105e8d:	0f a8                	push   %gs
  pushal
80105e8f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105e90:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105e94:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105e96:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105e98:	54                   	push   %esp
  call trap
80105e99:	e8 c2 00 00 00       	call   80105f60 <trap>
  addl $4, %esp
80105e9e:	83 c4 04             	add    $0x4,%esp

80105ea1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ea1:	61                   	popa   
  popl %gs
80105ea2:	0f a9                	pop    %gs
  popl %fs
80105ea4:	0f a1                	pop    %fs
  popl %es
80105ea6:	07                   	pop    %es
  popl %ds
80105ea7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ea8:	83 c4 08             	add    $0x8,%esp
  iret
80105eab:	cf                   	iret   
80105eac:	66 90                	xchg   %ax,%ax
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105eb5:	31 c0                	xor    %eax,%eax
{
80105eb7:	89 e5                	mov    %esp,%ebp
80105eb9:	83 ec 08             	sub    $0x8,%esp
80105ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105ec0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105ec7:	c7 04 c5 02 60 11 80 	movl   $0x8e000008,-0x7fee9ffe(,%eax,8)
80105ece:	08 00 00 8e 
80105ed2:	66 89 14 c5 00 60 11 	mov    %dx,-0x7feea000(,%eax,8)
80105ed9:	80 
80105eda:	c1 ea 10             	shr    $0x10,%edx
80105edd:	66 89 14 c5 06 60 11 	mov    %dx,-0x7fee9ffa(,%eax,8)
80105ee4:	80 
  for(i = 0; i < 256; i++)
80105ee5:	83 c0 01             	add    $0x1,%eax
80105ee8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105eed:	75 d1                	jne    80105ec0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105eef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ef2:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105ef7:	c7 05 02 62 11 80 08 	movl   $0xef000008,0x80116202
80105efe:	00 00 ef 
  initlock(&tickslock, "time");
80105f01:	68 a9 7e 10 80       	push   $0x80107ea9
80105f06:	68 c0 5f 11 80       	push   $0x80115fc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f0b:	66 a3 00 62 11 80    	mov    %ax,0x80116200
80105f11:	c1 e8 10             	shr    $0x10,%eax
80105f14:	66 a3 06 62 11 80    	mov    %ax,0x80116206
  initlock(&tickslock, "time");
80105f1a:	e8 41 ea ff ff       	call   80104960 <initlock>
}
80105f1f:	83 c4 10             	add    $0x10,%esp
80105f22:	c9                   	leave  
80105f23:	c3                   	ret    
80105f24:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f2f:	90                   	nop

80105f30 <idtinit>:

void
idtinit(void)
{
80105f30:	f3 0f 1e fb          	endbr32 
80105f34:	55                   	push   %ebp
  pd[0] = size-1;
80105f35:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105f3a:	89 e5                	mov    %esp,%ebp
80105f3c:	83 ec 10             	sub    $0x10,%esp
80105f3f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105f43:	b8 00 60 11 80       	mov    $0x80116000,%eax
80105f48:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105f4c:	c1 e8 10             	shr    $0x10,%eax
80105f4f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105f53:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105f56:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105f59:	c9                   	leave  
80105f5a:	c3                   	ret    
80105f5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f5f:	90                   	nop

80105f60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	57                   	push   %edi
80105f68:	56                   	push   %esi
80105f69:	53                   	push   %ebx
80105f6a:	83 ec 1c             	sub    $0x1c,%esp
80105f6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105f70:	8b 43 30             	mov    0x30(%ebx),%eax
80105f73:	83 f8 40             	cmp    $0x40,%eax
80105f76:	0f 84 bc 01 00 00    	je     80106138 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105f7c:	83 e8 20             	sub    $0x20,%eax
80105f7f:	83 f8 1f             	cmp    $0x1f,%eax
80105f82:	77 08                	ja     80105f8c <trap+0x2c>
80105f84:	3e ff 24 85 50 7f 10 	notrack jmp *-0x7fef80b0(,%eax,4)
80105f8b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f8c:	e8 1f da ff ff       	call   801039b0 <myproc>
80105f91:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f94:	85 c0                	test   %eax,%eax
80105f96:	0f 84 eb 01 00 00    	je     80106187 <trap+0x227>
80105f9c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105fa0:	0f 84 e1 01 00 00    	je     80106187 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105fa6:	0f 20 d1             	mov    %cr2,%ecx
80105fa9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fac:	e8 df d9 ff ff       	call   80103990 <cpuid>
80105fb1:	8b 73 30             	mov    0x30(%ebx),%esi
80105fb4:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105fb7:	8b 43 34             	mov    0x34(%ebx),%eax
80105fba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105fbd:	e8 ee d9 ff ff       	call   801039b0 <myproc>
80105fc2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105fc5:	e8 e6 d9 ff ff       	call   801039b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fca:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105fcd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105fd0:	51                   	push   %ecx
80105fd1:	57                   	push   %edi
80105fd2:	52                   	push   %edx
80105fd3:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fd6:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105fd7:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105fda:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105fdd:	56                   	push   %esi
80105fde:	ff 70 10             	pushl  0x10(%eax)
80105fe1:	68 0c 7f 10 80       	push   $0x80107f0c
80105fe6:	e8 c5 a6 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105feb:	83 c4 20             	add    $0x20,%esp
80105fee:	e8 bd d9 ff ff       	call   801039b0 <myproc>
80105ff3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ffa:	e8 b1 d9 ff ff       	call   801039b0 <myproc>
80105fff:	85 c0                	test   %eax,%eax
80106001:	74 1d                	je     80106020 <trap+0xc0>
80106003:	e8 a8 d9 ff ff       	call   801039b0 <myproc>
80106008:	8b 50 24             	mov    0x24(%eax),%edx
8010600b:	85 d2                	test   %edx,%edx
8010600d:	74 11                	je     80106020 <trap+0xc0>
8010600f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106013:	83 e0 03             	and    $0x3,%eax
80106016:	66 83 f8 03          	cmp    $0x3,%ax
8010601a:	0f 84 50 01 00 00    	je     80106170 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106020:	e8 8b d9 ff ff       	call   801039b0 <myproc>
80106025:	85 c0                	test   %eax,%eax
80106027:	74 0f                	je     80106038 <trap+0xd8>
80106029:	e8 82 d9 ff ff       	call   801039b0 <myproc>
8010602e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106032:	0f 84 e8 00 00 00    	je     80106120 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106038:	e8 73 d9 ff ff       	call   801039b0 <myproc>
8010603d:	85 c0                	test   %eax,%eax
8010603f:	74 1d                	je     8010605e <trap+0xfe>
80106041:	e8 6a d9 ff ff       	call   801039b0 <myproc>
80106046:	8b 40 24             	mov    0x24(%eax),%eax
80106049:	85 c0                	test   %eax,%eax
8010604b:	74 11                	je     8010605e <trap+0xfe>
8010604d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106051:	83 e0 03             	and    $0x3,%eax
80106054:	66 83 f8 03          	cmp    $0x3,%ax
80106058:	0f 84 03 01 00 00    	je     80106161 <trap+0x201>
    exit();
}
8010605e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106061:	5b                   	pop    %ebx
80106062:	5e                   	pop    %esi
80106063:	5f                   	pop    %edi
80106064:	5d                   	pop    %ebp
80106065:	c3                   	ret    
    ideintr();
80106066:	e8 95 c1 ff ff       	call   80102200 <ideintr>
    lapiceoi();
8010606b:	e8 70 c8 ff ff       	call   801028e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106070:	e8 3b d9 ff ff       	call   801039b0 <myproc>
80106075:	85 c0                	test   %eax,%eax
80106077:	75 8a                	jne    80106003 <trap+0xa3>
80106079:	eb a5                	jmp    80106020 <trap+0xc0>
    if(cpuid() == 0){
8010607b:	e8 10 d9 ff ff       	call   80103990 <cpuid>
80106080:	85 c0                	test   %eax,%eax
80106082:	75 e7                	jne    8010606b <trap+0x10b>
      acquire(&tickslock);
80106084:	83 ec 0c             	sub    $0xc,%esp
80106087:	68 c0 5f 11 80       	push   $0x80115fc0
8010608c:	e8 4f ea ff ff       	call   80104ae0 <acquire>
      wakeup(&ticks);
80106091:	c7 04 24 00 68 11 80 	movl   $0x80116800,(%esp)
      ticks++;
80106098:	83 05 00 68 11 80 01 	addl   $0x1,0x80116800
      wakeup(&ticks);
8010609f:	e8 6c e2 ff ff       	call   80104310 <wakeup>
      release(&tickslock);
801060a4:	c7 04 24 c0 5f 11 80 	movl   $0x80115fc0,(%esp)
801060ab:	e8 f0 ea ff ff       	call   80104ba0 <release>
801060b0:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801060b3:	eb b6                	jmp    8010606b <trap+0x10b>
    kbdintr();
801060b5:	e8 e6 c6 ff ff       	call   801027a0 <kbdintr>
    lapiceoi();
801060ba:	e8 21 c8 ff ff       	call   801028e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060bf:	e8 ec d8 ff ff       	call   801039b0 <myproc>
801060c4:	85 c0                	test   %eax,%eax
801060c6:	0f 85 37 ff ff ff    	jne    80106003 <trap+0xa3>
801060cc:	e9 4f ff ff ff       	jmp    80106020 <trap+0xc0>
    uartintr();
801060d1:	e8 4a 02 00 00       	call   80106320 <uartintr>
    lapiceoi();
801060d6:	e8 05 c8 ff ff       	call   801028e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060db:	e8 d0 d8 ff ff       	call   801039b0 <myproc>
801060e0:	85 c0                	test   %eax,%eax
801060e2:	0f 85 1b ff ff ff    	jne    80106003 <trap+0xa3>
801060e8:	e9 33 ff ff ff       	jmp    80106020 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801060ed:	8b 7b 38             	mov    0x38(%ebx),%edi
801060f0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801060f4:	e8 97 d8 ff ff       	call   80103990 <cpuid>
801060f9:	57                   	push   %edi
801060fa:	56                   	push   %esi
801060fb:	50                   	push   %eax
801060fc:	68 b4 7e 10 80       	push   $0x80107eb4
80106101:	e8 aa a5 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106106:	e8 d5 c7 ff ff       	call   801028e0 <lapiceoi>
    break;
8010610b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010610e:	e8 9d d8 ff ff       	call   801039b0 <myproc>
80106113:	85 c0                	test   %eax,%eax
80106115:	0f 85 e8 fe ff ff    	jne    80106003 <trap+0xa3>
8010611b:	e9 00 ff ff ff       	jmp    80106020 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80106120:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106124:	0f 85 0e ff ff ff    	jne    80106038 <trap+0xd8>
    yield();
8010612a:	e8 71 df ff ff       	call   801040a0 <yield>
8010612f:	e9 04 ff ff ff       	jmp    80106038 <trap+0xd8>
80106134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106138:	e8 73 d8 ff ff       	call   801039b0 <myproc>
8010613d:	8b 70 24             	mov    0x24(%eax),%esi
80106140:	85 f6                	test   %esi,%esi
80106142:	75 3c                	jne    80106180 <trap+0x220>
    myproc()->tf = tf;
80106144:	e8 67 d8 ff ff       	call   801039b0 <myproc>
80106149:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010614c:	e8 6f ee ff ff       	call   80104fc0 <syscall>
    if(myproc()->killed)
80106151:	e8 5a d8 ff ff       	call   801039b0 <myproc>
80106156:	8b 48 24             	mov    0x24(%eax),%ecx
80106159:	85 c9                	test   %ecx,%ecx
8010615b:	0f 84 fd fe ff ff    	je     8010605e <trap+0xfe>
}
80106161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106164:	5b                   	pop    %ebx
80106165:	5e                   	pop    %esi
80106166:	5f                   	pop    %edi
80106167:	5d                   	pop    %ebp
      exit();
80106168:	e9 e3 dd ff ff       	jmp    80103f50 <exit>
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106170:	e8 db dd ff ff       	call   80103f50 <exit>
80106175:	e9 a6 fe ff ff       	jmp    80106020 <trap+0xc0>
8010617a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106180:	e8 cb dd ff ff       	call   80103f50 <exit>
80106185:	eb bd                	jmp    80106144 <trap+0x1e4>
80106187:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010618a:	e8 01 d8 ff ff       	call   80103990 <cpuid>
8010618f:	83 ec 0c             	sub    $0xc,%esp
80106192:	56                   	push   %esi
80106193:	57                   	push   %edi
80106194:	50                   	push   %eax
80106195:	ff 73 30             	pushl  0x30(%ebx)
80106198:	68 d8 7e 10 80       	push   $0x80107ed8
8010619d:	e8 0e a5 ff ff       	call   801006b0 <cprintf>
      panic("trap");
801061a2:	83 c4 14             	add    $0x14,%esp
801061a5:	68 ae 7e 10 80       	push   $0x80107eae
801061aa:	e8 e1 a1 ff ff       	call   80100390 <panic>
801061af:	90                   	nop

801061b0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801061b0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801061b4:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
801061b9:	85 c0                	test   %eax,%eax
801061bb:	74 1b                	je     801061d8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801061bd:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061c2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801061c3:	a8 01                	test   $0x1,%al
801061c5:	74 11                	je     801061d8 <uartgetc+0x28>
801061c7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061cc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801061cd:	0f b6 c0             	movzbl %al,%eax
801061d0:	c3                   	ret    
801061d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801061d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061dd:	c3                   	ret    
801061de:	66 90                	xchg   %ax,%ax

801061e0 <uartputc.part.0>:
uartputc(int c)
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	57                   	push   %edi
801061e4:	89 c7                	mov    %eax,%edi
801061e6:	56                   	push   %esi
801061e7:	be fd 03 00 00       	mov    $0x3fd,%esi
801061ec:	53                   	push   %ebx
801061ed:	bb 80 00 00 00       	mov    $0x80,%ebx
801061f2:	83 ec 0c             	sub    $0xc,%esp
801061f5:	eb 1b                	jmp    80106212 <uartputc.part.0+0x32>
801061f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061fe:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106200:	83 ec 0c             	sub    $0xc,%esp
80106203:	6a 0a                	push   $0xa
80106205:	e8 f6 c6 ff ff       	call   80102900 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010620a:	83 c4 10             	add    $0x10,%esp
8010620d:	83 eb 01             	sub    $0x1,%ebx
80106210:	74 07                	je     80106219 <uartputc.part.0+0x39>
80106212:	89 f2                	mov    %esi,%edx
80106214:	ec                   	in     (%dx),%al
80106215:	a8 20                	test   $0x20,%al
80106217:	74 e7                	je     80106200 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106219:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010621e:	89 f8                	mov    %edi,%eax
80106220:	ee                   	out    %al,(%dx)
}
80106221:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106224:	5b                   	pop    %ebx
80106225:	5e                   	pop    %esi
80106226:	5f                   	pop    %edi
80106227:	5d                   	pop    %ebp
80106228:	c3                   	ret    
80106229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106230 <uartinit>:
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	31 c9                	xor    %ecx,%ecx
80106237:	89 c8                	mov    %ecx,%eax
80106239:	89 e5                	mov    %esp,%ebp
8010623b:	57                   	push   %edi
8010623c:	56                   	push   %esi
8010623d:	53                   	push   %ebx
8010623e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106243:	89 da                	mov    %ebx,%edx
80106245:	83 ec 0c             	sub    $0xc,%esp
80106248:	ee                   	out    %al,(%dx)
80106249:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010624e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106253:	89 fa                	mov    %edi,%edx
80106255:	ee                   	out    %al,(%dx)
80106256:	b8 0c 00 00 00       	mov    $0xc,%eax
8010625b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106260:	ee                   	out    %al,(%dx)
80106261:	be f9 03 00 00       	mov    $0x3f9,%esi
80106266:	89 c8                	mov    %ecx,%eax
80106268:	89 f2                	mov    %esi,%edx
8010626a:	ee                   	out    %al,(%dx)
8010626b:	b8 03 00 00 00       	mov    $0x3,%eax
80106270:	89 fa                	mov    %edi,%edx
80106272:	ee                   	out    %al,(%dx)
80106273:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106278:	89 c8                	mov    %ecx,%eax
8010627a:	ee                   	out    %al,(%dx)
8010627b:	b8 01 00 00 00       	mov    $0x1,%eax
80106280:	89 f2                	mov    %esi,%edx
80106282:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106283:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106288:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106289:	3c ff                	cmp    $0xff,%al
8010628b:	74 52                	je     801062df <uartinit+0xaf>
  uart = 1;
8010628d:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
80106294:	00 00 00 
80106297:	89 da                	mov    %ebx,%edx
80106299:	ec                   	in     (%dx),%al
8010629a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010629f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801062a0:	83 ec 08             	sub    $0x8,%esp
801062a3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
801062a8:	bb d0 7f 10 80       	mov    $0x80107fd0,%ebx
  ioapicenable(IRQ_COM1, 0);
801062ad:	6a 00                	push   $0x0
801062af:	6a 04                	push   $0x4
801062b1:	e8 9a c1 ff ff       	call   80102450 <ioapicenable>
801062b6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801062b9:	b8 78 00 00 00       	mov    $0x78,%eax
801062be:	eb 04                	jmp    801062c4 <uartinit+0x94>
801062c0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801062c4:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
801062ca:	85 d2                	test   %edx,%edx
801062cc:	74 08                	je     801062d6 <uartinit+0xa6>
    uartputc(*p);
801062ce:	0f be c0             	movsbl %al,%eax
801062d1:	e8 0a ff ff ff       	call   801061e0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801062d6:	89 f0                	mov    %esi,%eax
801062d8:	83 c3 01             	add    $0x1,%ebx
801062db:	84 c0                	test   %al,%al
801062dd:	75 e1                	jne    801062c0 <uartinit+0x90>
}
801062df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062e2:	5b                   	pop    %ebx
801062e3:	5e                   	pop    %esi
801062e4:	5f                   	pop    %edi
801062e5:	5d                   	pop    %ebp
801062e6:	c3                   	ret    
801062e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ee:	66 90                	xchg   %ax,%ax

801062f0 <uartputc>:
{
801062f0:	f3 0f 1e fb          	endbr32 
801062f4:	55                   	push   %ebp
  if(!uart)
801062f5:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
{
801062fb:	89 e5                	mov    %esp,%ebp
801062fd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106300:	85 d2                	test   %edx,%edx
80106302:	74 0c                	je     80106310 <uartputc+0x20>
}
80106304:	5d                   	pop    %ebp
80106305:	e9 d6 fe ff ff       	jmp    801061e0 <uartputc.part.0>
8010630a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106310:	5d                   	pop    %ebp
80106311:	c3                   	ret    
80106312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106320 <uartintr>:

void
uartintr(void)
{
80106320:	f3 0f 1e fb          	endbr32 
80106324:	55                   	push   %ebp
80106325:	89 e5                	mov    %esp,%ebp
80106327:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010632a:	68 b0 61 10 80       	push   $0x801061b0
8010632f:	e8 2c a5 ff ff       	call   80100860 <consoleintr>
}
80106334:	83 c4 10             	add    $0x10,%esp
80106337:	c9                   	leave  
80106338:	c3                   	ret    

80106339 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $0
8010633b:	6a 00                	push   $0x0
  jmp alltraps
8010633d:	e9 47 fb ff ff       	jmp    80105e89 <alltraps>

80106342 <vector1>:
.globl vector1
vector1:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $1
80106344:	6a 01                	push   $0x1
  jmp alltraps
80106346:	e9 3e fb ff ff       	jmp    80105e89 <alltraps>

8010634b <vector2>:
.globl vector2
vector2:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $2
8010634d:	6a 02                	push   $0x2
  jmp alltraps
8010634f:	e9 35 fb ff ff       	jmp    80105e89 <alltraps>

80106354 <vector3>:
.globl vector3
vector3:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $3
80106356:	6a 03                	push   $0x3
  jmp alltraps
80106358:	e9 2c fb ff ff       	jmp    80105e89 <alltraps>

8010635d <vector4>:
.globl vector4
vector4:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $4
8010635f:	6a 04                	push   $0x4
  jmp alltraps
80106361:	e9 23 fb ff ff       	jmp    80105e89 <alltraps>

80106366 <vector5>:
.globl vector5
vector5:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $5
80106368:	6a 05                	push   $0x5
  jmp alltraps
8010636a:	e9 1a fb ff ff       	jmp    80105e89 <alltraps>

8010636f <vector6>:
.globl vector6
vector6:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $6
80106371:	6a 06                	push   $0x6
  jmp alltraps
80106373:	e9 11 fb ff ff       	jmp    80105e89 <alltraps>

80106378 <vector7>:
.globl vector7
vector7:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $7
8010637a:	6a 07                	push   $0x7
  jmp alltraps
8010637c:	e9 08 fb ff ff       	jmp    80105e89 <alltraps>

80106381 <vector8>:
.globl vector8
vector8:
  pushl $8
80106381:	6a 08                	push   $0x8
  jmp alltraps
80106383:	e9 01 fb ff ff       	jmp    80105e89 <alltraps>

80106388 <vector9>:
.globl vector9
vector9:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $9
8010638a:	6a 09                	push   $0x9
  jmp alltraps
8010638c:	e9 f8 fa ff ff       	jmp    80105e89 <alltraps>

80106391 <vector10>:
.globl vector10
vector10:
  pushl $10
80106391:	6a 0a                	push   $0xa
  jmp alltraps
80106393:	e9 f1 fa ff ff       	jmp    80105e89 <alltraps>

80106398 <vector11>:
.globl vector11
vector11:
  pushl $11
80106398:	6a 0b                	push   $0xb
  jmp alltraps
8010639a:	e9 ea fa ff ff       	jmp    80105e89 <alltraps>

8010639f <vector12>:
.globl vector12
vector12:
  pushl $12
8010639f:	6a 0c                	push   $0xc
  jmp alltraps
801063a1:	e9 e3 fa ff ff       	jmp    80105e89 <alltraps>

801063a6 <vector13>:
.globl vector13
vector13:
  pushl $13
801063a6:	6a 0d                	push   $0xd
  jmp alltraps
801063a8:	e9 dc fa ff ff       	jmp    80105e89 <alltraps>

801063ad <vector14>:
.globl vector14
vector14:
  pushl $14
801063ad:	6a 0e                	push   $0xe
  jmp alltraps
801063af:	e9 d5 fa ff ff       	jmp    80105e89 <alltraps>

801063b4 <vector15>:
.globl vector15
vector15:
  pushl $0
801063b4:	6a 00                	push   $0x0
  pushl $15
801063b6:	6a 0f                	push   $0xf
  jmp alltraps
801063b8:	e9 cc fa ff ff       	jmp    80105e89 <alltraps>

801063bd <vector16>:
.globl vector16
vector16:
  pushl $0
801063bd:	6a 00                	push   $0x0
  pushl $16
801063bf:	6a 10                	push   $0x10
  jmp alltraps
801063c1:	e9 c3 fa ff ff       	jmp    80105e89 <alltraps>

801063c6 <vector17>:
.globl vector17
vector17:
  pushl $17
801063c6:	6a 11                	push   $0x11
  jmp alltraps
801063c8:	e9 bc fa ff ff       	jmp    80105e89 <alltraps>

801063cd <vector18>:
.globl vector18
vector18:
  pushl $0
801063cd:	6a 00                	push   $0x0
  pushl $18
801063cf:	6a 12                	push   $0x12
  jmp alltraps
801063d1:	e9 b3 fa ff ff       	jmp    80105e89 <alltraps>

801063d6 <vector19>:
.globl vector19
vector19:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $19
801063d8:	6a 13                	push   $0x13
  jmp alltraps
801063da:	e9 aa fa ff ff       	jmp    80105e89 <alltraps>

801063df <vector20>:
.globl vector20
vector20:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $20
801063e1:	6a 14                	push   $0x14
  jmp alltraps
801063e3:	e9 a1 fa ff ff       	jmp    80105e89 <alltraps>

801063e8 <vector21>:
.globl vector21
vector21:
  pushl $0
801063e8:	6a 00                	push   $0x0
  pushl $21
801063ea:	6a 15                	push   $0x15
  jmp alltraps
801063ec:	e9 98 fa ff ff       	jmp    80105e89 <alltraps>

801063f1 <vector22>:
.globl vector22
vector22:
  pushl $0
801063f1:	6a 00                	push   $0x0
  pushl $22
801063f3:	6a 16                	push   $0x16
  jmp alltraps
801063f5:	e9 8f fa ff ff       	jmp    80105e89 <alltraps>

801063fa <vector23>:
.globl vector23
vector23:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $23
801063fc:	6a 17                	push   $0x17
  jmp alltraps
801063fe:	e9 86 fa ff ff       	jmp    80105e89 <alltraps>

80106403 <vector24>:
.globl vector24
vector24:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $24
80106405:	6a 18                	push   $0x18
  jmp alltraps
80106407:	e9 7d fa ff ff       	jmp    80105e89 <alltraps>

8010640c <vector25>:
.globl vector25
vector25:
  pushl $0
8010640c:	6a 00                	push   $0x0
  pushl $25
8010640e:	6a 19                	push   $0x19
  jmp alltraps
80106410:	e9 74 fa ff ff       	jmp    80105e89 <alltraps>

80106415 <vector26>:
.globl vector26
vector26:
  pushl $0
80106415:	6a 00                	push   $0x0
  pushl $26
80106417:	6a 1a                	push   $0x1a
  jmp alltraps
80106419:	e9 6b fa ff ff       	jmp    80105e89 <alltraps>

8010641e <vector27>:
.globl vector27
vector27:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $27
80106420:	6a 1b                	push   $0x1b
  jmp alltraps
80106422:	e9 62 fa ff ff       	jmp    80105e89 <alltraps>

80106427 <vector28>:
.globl vector28
vector28:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $28
80106429:	6a 1c                	push   $0x1c
  jmp alltraps
8010642b:	e9 59 fa ff ff       	jmp    80105e89 <alltraps>

80106430 <vector29>:
.globl vector29
vector29:
  pushl $0
80106430:	6a 00                	push   $0x0
  pushl $29
80106432:	6a 1d                	push   $0x1d
  jmp alltraps
80106434:	e9 50 fa ff ff       	jmp    80105e89 <alltraps>

80106439 <vector30>:
.globl vector30
vector30:
  pushl $0
80106439:	6a 00                	push   $0x0
  pushl $30
8010643b:	6a 1e                	push   $0x1e
  jmp alltraps
8010643d:	e9 47 fa ff ff       	jmp    80105e89 <alltraps>

80106442 <vector31>:
.globl vector31
vector31:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $31
80106444:	6a 1f                	push   $0x1f
  jmp alltraps
80106446:	e9 3e fa ff ff       	jmp    80105e89 <alltraps>

8010644b <vector32>:
.globl vector32
vector32:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $32
8010644d:	6a 20                	push   $0x20
  jmp alltraps
8010644f:	e9 35 fa ff ff       	jmp    80105e89 <alltraps>

80106454 <vector33>:
.globl vector33
vector33:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $33
80106456:	6a 21                	push   $0x21
  jmp alltraps
80106458:	e9 2c fa ff ff       	jmp    80105e89 <alltraps>

8010645d <vector34>:
.globl vector34
vector34:
  pushl $0
8010645d:	6a 00                	push   $0x0
  pushl $34
8010645f:	6a 22                	push   $0x22
  jmp alltraps
80106461:	e9 23 fa ff ff       	jmp    80105e89 <alltraps>

80106466 <vector35>:
.globl vector35
vector35:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $35
80106468:	6a 23                	push   $0x23
  jmp alltraps
8010646a:	e9 1a fa ff ff       	jmp    80105e89 <alltraps>

8010646f <vector36>:
.globl vector36
vector36:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $36
80106471:	6a 24                	push   $0x24
  jmp alltraps
80106473:	e9 11 fa ff ff       	jmp    80105e89 <alltraps>

80106478 <vector37>:
.globl vector37
vector37:
  pushl $0
80106478:	6a 00                	push   $0x0
  pushl $37
8010647a:	6a 25                	push   $0x25
  jmp alltraps
8010647c:	e9 08 fa ff ff       	jmp    80105e89 <alltraps>

80106481 <vector38>:
.globl vector38
vector38:
  pushl $0
80106481:	6a 00                	push   $0x0
  pushl $38
80106483:	6a 26                	push   $0x26
  jmp alltraps
80106485:	e9 ff f9 ff ff       	jmp    80105e89 <alltraps>

8010648a <vector39>:
.globl vector39
vector39:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $39
8010648c:	6a 27                	push   $0x27
  jmp alltraps
8010648e:	e9 f6 f9 ff ff       	jmp    80105e89 <alltraps>

80106493 <vector40>:
.globl vector40
vector40:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $40
80106495:	6a 28                	push   $0x28
  jmp alltraps
80106497:	e9 ed f9 ff ff       	jmp    80105e89 <alltraps>

8010649c <vector41>:
.globl vector41
vector41:
  pushl $0
8010649c:	6a 00                	push   $0x0
  pushl $41
8010649e:	6a 29                	push   $0x29
  jmp alltraps
801064a0:	e9 e4 f9 ff ff       	jmp    80105e89 <alltraps>

801064a5 <vector42>:
.globl vector42
vector42:
  pushl $0
801064a5:	6a 00                	push   $0x0
  pushl $42
801064a7:	6a 2a                	push   $0x2a
  jmp alltraps
801064a9:	e9 db f9 ff ff       	jmp    80105e89 <alltraps>

801064ae <vector43>:
.globl vector43
vector43:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $43
801064b0:	6a 2b                	push   $0x2b
  jmp alltraps
801064b2:	e9 d2 f9 ff ff       	jmp    80105e89 <alltraps>

801064b7 <vector44>:
.globl vector44
vector44:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $44
801064b9:	6a 2c                	push   $0x2c
  jmp alltraps
801064bb:	e9 c9 f9 ff ff       	jmp    80105e89 <alltraps>

801064c0 <vector45>:
.globl vector45
vector45:
  pushl $0
801064c0:	6a 00                	push   $0x0
  pushl $45
801064c2:	6a 2d                	push   $0x2d
  jmp alltraps
801064c4:	e9 c0 f9 ff ff       	jmp    80105e89 <alltraps>

801064c9 <vector46>:
.globl vector46
vector46:
  pushl $0
801064c9:	6a 00                	push   $0x0
  pushl $46
801064cb:	6a 2e                	push   $0x2e
  jmp alltraps
801064cd:	e9 b7 f9 ff ff       	jmp    80105e89 <alltraps>

801064d2 <vector47>:
.globl vector47
vector47:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $47
801064d4:	6a 2f                	push   $0x2f
  jmp alltraps
801064d6:	e9 ae f9 ff ff       	jmp    80105e89 <alltraps>

801064db <vector48>:
.globl vector48
vector48:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $48
801064dd:	6a 30                	push   $0x30
  jmp alltraps
801064df:	e9 a5 f9 ff ff       	jmp    80105e89 <alltraps>

801064e4 <vector49>:
.globl vector49
vector49:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $49
801064e6:	6a 31                	push   $0x31
  jmp alltraps
801064e8:	e9 9c f9 ff ff       	jmp    80105e89 <alltraps>

801064ed <vector50>:
.globl vector50
vector50:
  pushl $0
801064ed:	6a 00                	push   $0x0
  pushl $50
801064ef:	6a 32                	push   $0x32
  jmp alltraps
801064f1:	e9 93 f9 ff ff       	jmp    80105e89 <alltraps>

801064f6 <vector51>:
.globl vector51
vector51:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $51
801064f8:	6a 33                	push   $0x33
  jmp alltraps
801064fa:	e9 8a f9 ff ff       	jmp    80105e89 <alltraps>

801064ff <vector52>:
.globl vector52
vector52:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $52
80106501:	6a 34                	push   $0x34
  jmp alltraps
80106503:	e9 81 f9 ff ff       	jmp    80105e89 <alltraps>

80106508 <vector53>:
.globl vector53
vector53:
  pushl $0
80106508:	6a 00                	push   $0x0
  pushl $53
8010650a:	6a 35                	push   $0x35
  jmp alltraps
8010650c:	e9 78 f9 ff ff       	jmp    80105e89 <alltraps>

80106511 <vector54>:
.globl vector54
vector54:
  pushl $0
80106511:	6a 00                	push   $0x0
  pushl $54
80106513:	6a 36                	push   $0x36
  jmp alltraps
80106515:	e9 6f f9 ff ff       	jmp    80105e89 <alltraps>

8010651a <vector55>:
.globl vector55
vector55:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $55
8010651c:	6a 37                	push   $0x37
  jmp alltraps
8010651e:	e9 66 f9 ff ff       	jmp    80105e89 <alltraps>

80106523 <vector56>:
.globl vector56
vector56:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $56
80106525:	6a 38                	push   $0x38
  jmp alltraps
80106527:	e9 5d f9 ff ff       	jmp    80105e89 <alltraps>

8010652c <vector57>:
.globl vector57
vector57:
  pushl $0
8010652c:	6a 00                	push   $0x0
  pushl $57
8010652e:	6a 39                	push   $0x39
  jmp alltraps
80106530:	e9 54 f9 ff ff       	jmp    80105e89 <alltraps>

80106535 <vector58>:
.globl vector58
vector58:
  pushl $0
80106535:	6a 00                	push   $0x0
  pushl $58
80106537:	6a 3a                	push   $0x3a
  jmp alltraps
80106539:	e9 4b f9 ff ff       	jmp    80105e89 <alltraps>

8010653e <vector59>:
.globl vector59
vector59:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $59
80106540:	6a 3b                	push   $0x3b
  jmp alltraps
80106542:	e9 42 f9 ff ff       	jmp    80105e89 <alltraps>

80106547 <vector60>:
.globl vector60
vector60:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $60
80106549:	6a 3c                	push   $0x3c
  jmp alltraps
8010654b:	e9 39 f9 ff ff       	jmp    80105e89 <alltraps>

80106550 <vector61>:
.globl vector61
vector61:
  pushl $0
80106550:	6a 00                	push   $0x0
  pushl $61
80106552:	6a 3d                	push   $0x3d
  jmp alltraps
80106554:	e9 30 f9 ff ff       	jmp    80105e89 <alltraps>

80106559 <vector62>:
.globl vector62
vector62:
  pushl $0
80106559:	6a 00                	push   $0x0
  pushl $62
8010655b:	6a 3e                	push   $0x3e
  jmp alltraps
8010655d:	e9 27 f9 ff ff       	jmp    80105e89 <alltraps>

80106562 <vector63>:
.globl vector63
vector63:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $63
80106564:	6a 3f                	push   $0x3f
  jmp alltraps
80106566:	e9 1e f9 ff ff       	jmp    80105e89 <alltraps>

8010656b <vector64>:
.globl vector64
vector64:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $64
8010656d:	6a 40                	push   $0x40
  jmp alltraps
8010656f:	e9 15 f9 ff ff       	jmp    80105e89 <alltraps>

80106574 <vector65>:
.globl vector65
vector65:
  pushl $0
80106574:	6a 00                	push   $0x0
  pushl $65
80106576:	6a 41                	push   $0x41
  jmp alltraps
80106578:	e9 0c f9 ff ff       	jmp    80105e89 <alltraps>

8010657d <vector66>:
.globl vector66
vector66:
  pushl $0
8010657d:	6a 00                	push   $0x0
  pushl $66
8010657f:	6a 42                	push   $0x42
  jmp alltraps
80106581:	e9 03 f9 ff ff       	jmp    80105e89 <alltraps>

80106586 <vector67>:
.globl vector67
vector67:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $67
80106588:	6a 43                	push   $0x43
  jmp alltraps
8010658a:	e9 fa f8 ff ff       	jmp    80105e89 <alltraps>

8010658f <vector68>:
.globl vector68
vector68:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $68
80106591:	6a 44                	push   $0x44
  jmp alltraps
80106593:	e9 f1 f8 ff ff       	jmp    80105e89 <alltraps>

80106598 <vector69>:
.globl vector69
vector69:
  pushl $0
80106598:	6a 00                	push   $0x0
  pushl $69
8010659a:	6a 45                	push   $0x45
  jmp alltraps
8010659c:	e9 e8 f8 ff ff       	jmp    80105e89 <alltraps>

801065a1 <vector70>:
.globl vector70
vector70:
  pushl $0
801065a1:	6a 00                	push   $0x0
  pushl $70
801065a3:	6a 46                	push   $0x46
  jmp alltraps
801065a5:	e9 df f8 ff ff       	jmp    80105e89 <alltraps>

801065aa <vector71>:
.globl vector71
vector71:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $71
801065ac:	6a 47                	push   $0x47
  jmp alltraps
801065ae:	e9 d6 f8 ff ff       	jmp    80105e89 <alltraps>

801065b3 <vector72>:
.globl vector72
vector72:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $72
801065b5:	6a 48                	push   $0x48
  jmp alltraps
801065b7:	e9 cd f8 ff ff       	jmp    80105e89 <alltraps>

801065bc <vector73>:
.globl vector73
vector73:
  pushl $0
801065bc:	6a 00                	push   $0x0
  pushl $73
801065be:	6a 49                	push   $0x49
  jmp alltraps
801065c0:	e9 c4 f8 ff ff       	jmp    80105e89 <alltraps>

801065c5 <vector74>:
.globl vector74
vector74:
  pushl $0
801065c5:	6a 00                	push   $0x0
  pushl $74
801065c7:	6a 4a                	push   $0x4a
  jmp alltraps
801065c9:	e9 bb f8 ff ff       	jmp    80105e89 <alltraps>

801065ce <vector75>:
.globl vector75
vector75:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $75
801065d0:	6a 4b                	push   $0x4b
  jmp alltraps
801065d2:	e9 b2 f8 ff ff       	jmp    80105e89 <alltraps>

801065d7 <vector76>:
.globl vector76
vector76:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $76
801065d9:	6a 4c                	push   $0x4c
  jmp alltraps
801065db:	e9 a9 f8 ff ff       	jmp    80105e89 <alltraps>

801065e0 <vector77>:
.globl vector77
vector77:
  pushl $0
801065e0:	6a 00                	push   $0x0
  pushl $77
801065e2:	6a 4d                	push   $0x4d
  jmp alltraps
801065e4:	e9 a0 f8 ff ff       	jmp    80105e89 <alltraps>

801065e9 <vector78>:
.globl vector78
vector78:
  pushl $0
801065e9:	6a 00                	push   $0x0
  pushl $78
801065eb:	6a 4e                	push   $0x4e
  jmp alltraps
801065ed:	e9 97 f8 ff ff       	jmp    80105e89 <alltraps>

801065f2 <vector79>:
.globl vector79
vector79:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $79
801065f4:	6a 4f                	push   $0x4f
  jmp alltraps
801065f6:	e9 8e f8 ff ff       	jmp    80105e89 <alltraps>

801065fb <vector80>:
.globl vector80
vector80:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $80
801065fd:	6a 50                	push   $0x50
  jmp alltraps
801065ff:	e9 85 f8 ff ff       	jmp    80105e89 <alltraps>

80106604 <vector81>:
.globl vector81
vector81:
  pushl $0
80106604:	6a 00                	push   $0x0
  pushl $81
80106606:	6a 51                	push   $0x51
  jmp alltraps
80106608:	e9 7c f8 ff ff       	jmp    80105e89 <alltraps>

8010660d <vector82>:
.globl vector82
vector82:
  pushl $0
8010660d:	6a 00                	push   $0x0
  pushl $82
8010660f:	6a 52                	push   $0x52
  jmp alltraps
80106611:	e9 73 f8 ff ff       	jmp    80105e89 <alltraps>

80106616 <vector83>:
.globl vector83
vector83:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $83
80106618:	6a 53                	push   $0x53
  jmp alltraps
8010661a:	e9 6a f8 ff ff       	jmp    80105e89 <alltraps>

8010661f <vector84>:
.globl vector84
vector84:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $84
80106621:	6a 54                	push   $0x54
  jmp alltraps
80106623:	e9 61 f8 ff ff       	jmp    80105e89 <alltraps>

80106628 <vector85>:
.globl vector85
vector85:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $85
8010662a:	6a 55                	push   $0x55
  jmp alltraps
8010662c:	e9 58 f8 ff ff       	jmp    80105e89 <alltraps>

80106631 <vector86>:
.globl vector86
vector86:
  pushl $0
80106631:	6a 00                	push   $0x0
  pushl $86
80106633:	6a 56                	push   $0x56
  jmp alltraps
80106635:	e9 4f f8 ff ff       	jmp    80105e89 <alltraps>

8010663a <vector87>:
.globl vector87
vector87:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $87
8010663c:	6a 57                	push   $0x57
  jmp alltraps
8010663e:	e9 46 f8 ff ff       	jmp    80105e89 <alltraps>

80106643 <vector88>:
.globl vector88
vector88:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $88
80106645:	6a 58                	push   $0x58
  jmp alltraps
80106647:	e9 3d f8 ff ff       	jmp    80105e89 <alltraps>

8010664c <vector89>:
.globl vector89
vector89:
  pushl $0
8010664c:	6a 00                	push   $0x0
  pushl $89
8010664e:	6a 59                	push   $0x59
  jmp alltraps
80106650:	e9 34 f8 ff ff       	jmp    80105e89 <alltraps>

80106655 <vector90>:
.globl vector90
vector90:
  pushl $0
80106655:	6a 00                	push   $0x0
  pushl $90
80106657:	6a 5a                	push   $0x5a
  jmp alltraps
80106659:	e9 2b f8 ff ff       	jmp    80105e89 <alltraps>

8010665e <vector91>:
.globl vector91
vector91:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $91
80106660:	6a 5b                	push   $0x5b
  jmp alltraps
80106662:	e9 22 f8 ff ff       	jmp    80105e89 <alltraps>

80106667 <vector92>:
.globl vector92
vector92:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $92
80106669:	6a 5c                	push   $0x5c
  jmp alltraps
8010666b:	e9 19 f8 ff ff       	jmp    80105e89 <alltraps>

80106670 <vector93>:
.globl vector93
vector93:
  pushl $0
80106670:	6a 00                	push   $0x0
  pushl $93
80106672:	6a 5d                	push   $0x5d
  jmp alltraps
80106674:	e9 10 f8 ff ff       	jmp    80105e89 <alltraps>

80106679 <vector94>:
.globl vector94
vector94:
  pushl $0
80106679:	6a 00                	push   $0x0
  pushl $94
8010667b:	6a 5e                	push   $0x5e
  jmp alltraps
8010667d:	e9 07 f8 ff ff       	jmp    80105e89 <alltraps>

80106682 <vector95>:
.globl vector95
vector95:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $95
80106684:	6a 5f                	push   $0x5f
  jmp alltraps
80106686:	e9 fe f7 ff ff       	jmp    80105e89 <alltraps>

8010668b <vector96>:
.globl vector96
vector96:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $96
8010668d:	6a 60                	push   $0x60
  jmp alltraps
8010668f:	e9 f5 f7 ff ff       	jmp    80105e89 <alltraps>

80106694 <vector97>:
.globl vector97
vector97:
  pushl $0
80106694:	6a 00                	push   $0x0
  pushl $97
80106696:	6a 61                	push   $0x61
  jmp alltraps
80106698:	e9 ec f7 ff ff       	jmp    80105e89 <alltraps>

8010669d <vector98>:
.globl vector98
vector98:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $98
8010669f:	6a 62                	push   $0x62
  jmp alltraps
801066a1:	e9 e3 f7 ff ff       	jmp    80105e89 <alltraps>

801066a6 <vector99>:
.globl vector99
vector99:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $99
801066a8:	6a 63                	push   $0x63
  jmp alltraps
801066aa:	e9 da f7 ff ff       	jmp    80105e89 <alltraps>

801066af <vector100>:
.globl vector100
vector100:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $100
801066b1:	6a 64                	push   $0x64
  jmp alltraps
801066b3:	e9 d1 f7 ff ff       	jmp    80105e89 <alltraps>

801066b8 <vector101>:
.globl vector101
vector101:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $101
801066ba:	6a 65                	push   $0x65
  jmp alltraps
801066bc:	e9 c8 f7 ff ff       	jmp    80105e89 <alltraps>

801066c1 <vector102>:
.globl vector102
vector102:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $102
801066c3:	6a 66                	push   $0x66
  jmp alltraps
801066c5:	e9 bf f7 ff ff       	jmp    80105e89 <alltraps>

801066ca <vector103>:
.globl vector103
vector103:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $103
801066cc:	6a 67                	push   $0x67
  jmp alltraps
801066ce:	e9 b6 f7 ff ff       	jmp    80105e89 <alltraps>

801066d3 <vector104>:
.globl vector104
vector104:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $104
801066d5:	6a 68                	push   $0x68
  jmp alltraps
801066d7:	e9 ad f7 ff ff       	jmp    80105e89 <alltraps>

801066dc <vector105>:
.globl vector105
vector105:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $105
801066de:	6a 69                	push   $0x69
  jmp alltraps
801066e0:	e9 a4 f7 ff ff       	jmp    80105e89 <alltraps>

801066e5 <vector106>:
.globl vector106
vector106:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $106
801066e7:	6a 6a                	push   $0x6a
  jmp alltraps
801066e9:	e9 9b f7 ff ff       	jmp    80105e89 <alltraps>

801066ee <vector107>:
.globl vector107
vector107:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $107
801066f0:	6a 6b                	push   $0x6b
  jmp alltraps
801066f2:	e9 92 f7 ff ff       	jmp    80105e89 <alltraps>

801066f7 <vector108>:
.globl vector108
vector108:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $108
801066f9:	6a 6c                	push   $0x6c
  jmp alltraps
801066fb:	e9 89 f7 ff ff       	jmp    80105e89 <alltraps>

80106700 <vector109>:
.globl vector109
vector109:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $109
80106702:	6a 6d                	push   $0x6d
  jmp alltraps
80106704:	e9 80 f7 ff ff       	jmp    80105e89 <alltraps>

80106709 <vector110>:
.globl vector110
vector110:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $110
8010670b:	6a 6e                	push   $0x6e
  jmp alltraps
8010670d:	e9 77 f7 ff ff       	jmp    80105e89 <alltraps>

80106712 <vector111>:
.globl vector111
vector111:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $111
80106714:	6a 6f                	push   $0x6f
  jmp alltraps
80106716:	e9 6e f7 ff ff       	jmp    80105e89 <alltraps>

8010671b <vector112>:
.globl vector112
vector112:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $112
8010671d:	6a 70                	push   $0x70
  jmp alltraps
8010671f:	e9 65 f7 ff ff       	jmp    80105e89 <alltraps>

80106724 <vector113>:
.globl vector113
vector113:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $113
80106726:	6a 71                	push   $0x71
  jmp alltraps
80106728:	e9 5c f7 ff ff       	jmp    80105e89 <alltraps>

8010672d <vector114>:
.globl vector114
vector114:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $114
8010672f:	6a 72                	push   $0x72
  jmp alltraps
80106731:	e9 53 f7 ff ff       	jmp    80105e89 <alltraps>

80106736 <vector115>:
.globl vector115
vector115:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $115
80106738:	6a 73                	push   $0x73
  jmp alltraps
8010673a:	e9 4a f7 ff ff       	jmp    80105e89 <alltraps>

8010673f <vector116>:
.globl vector116
vector116:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $116
80106741:	6a 74                	push   $0x74
  jmp alltraps
80106743:	e9 41 f7 ff ff       	jmp    80105e89 <alltraps>

80106748 <vector117>:
.globl vector117
vector117:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $117
8010674a:	6a 75                	push   $0x75
  jmp alltraps
8010674c:	e9 38 f7 ff ff       	jmp    80105e89 <alltraps>

80106751 <vector118>:
.globl vector118
vector118:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $118
80106753:	6a 76                	push   $0x76
  jmp alltraps
80106755:	e9 2f f7 ff ff       	jmp    80105e89 <alltraps>

8010675a <vector119>:
.globl vector119
vector119:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $119
8010675c:	6a 77                	push   $0x77
  jmp alltraps
8010675e:	e9 26 f7 ff ff       	jmp    80105e89 <alltraps>

80106763 <vector120>:
.globl vector120
vector120:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $120
80106765:	6a 78                	push   $0x78
  jmp alltraps
80106767:	e9 1d f7 ff ff       	jmp    80105e89 <alltraps>

8010676c <vector121>:
.globl vector121
vector121:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $121
8010676e:	6a 79                	push   $0x79
  jmp alltraps
80106770:	e9 14 f7 ff ff       	jmp    80105e89 <alltraps>

80106775 <vector122>:
.globl vector122
vector122:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $122
80106777:	6a 7a                	push   $0x7a
  jmp alltraps
80106779:	e9 0b f7 ff ff       	jmp    80105e89 <alltraps>

8010677e <vector123>:
.globl vector123
vector123:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $123
80106780:	6a 7b                	push   $0x7b
  jmp alltraps
80106782:	e9 02 f7 ff ff       	jmp    80105e89 <alltraps>

80106787 <vector124>:
.globl vector124
vector124:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $124
80106789:	6a 7c                	push   $0x7c
  jmp alltraps
8010678b:	e9 f9 f6 ff ff       	jmp    80105e89 <alltraps>

80106790 <vector125>:
.globl vector125
vector125:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $125
80106792:	6a 7d                	push   $0x7d
  jmp alltraps
80106794:	e9 f0 f6 ff ff       	jmp    80105e89 <alltraps>

80106799 <vector126>:
.globl vector126
vector126:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $126
8010679b:	6a 7e                	push   $0x7e
  jmp alltraps
8010679d:	e9 e7 f6 ff ff       	jmp    80105e89 <alltraps>

801067a2 <vector127>:
.globl vector127
vector127:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $127
801067a4:	6a 7f                	push   $0x7f
  jmp alltraps
801067a6:	e9 de f6 ff ff       	jmp    80105e89 <alltraps>

801067ab <vector128>:
.globl vector128
vector128:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $128
801067ad:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801067b2:	e9 d2 f6 ff ff       	jmp    80105e89 <alltraps>

801067b7 <vector129>:
.globl vector129
vector129:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $129
801067b9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801067be:	e9 c6 f6 ff ff       	jmp    80105e89 <alltraps>

801067c3 <vector130>:
.globl vector130
vector130:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $130
801067c5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801067ca:	e9 ba f6 ff ff       	jmp    80105e89 <alltraps>

801067cf <vector131>:
.globl vector131
vector131:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $131
801067d1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801067d6:	e9 ae f6 ff ff       	jmp    80105e89 <alltraps>

801067db <vector132>:
.globl vector132
vector132:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $132
801067dd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801067e2:	e9 a2 f6 ff ff       	jmp    80105e89 <alltraps>

801067e7 <vector133>:
.globl vector133
vector133:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $133
801067e9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801067ee:	e9 96 f6 ff ff       	jmp    80105e89 <alltraps>

801067f3 <vector134>:
.globl vector134
vector134:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $134
801067f5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801067fa:	e9 8a f6 ff ff       	jmp    80105e89 <alltraps>

801067ff <vector135>:
.globl vector135
vector135:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $135
80106801:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106806:	e9 7e f6 ff ff       	jmp    80105e89 <alltraps>

8010680b <vector136>:
.globl vector136
vector136:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $136
8010680d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106812:	e9 72 f6 ff ff       	jmp    80105e89 <alltraps>

80106817 <vector137>:
.globl vector137
vector137:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $137
80106819:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010681e:	e9 66 f6 ff ff       	jmp    80105e89 <alltraps>

80106823 <vector138>:
.globl vector138
vector138:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $138
80106825:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010682a:	e9 5a f6 ff ff       	jmp    80105e89 <alltraps>

8010682f <vector139>:
.globl vector139
vector139:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $139
80106831:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106836:	e9 4e f6 ff ff       	jmp    80105e89 <alltraps>

8010683b <vector140>:
.globl vector140
vector140:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $140
8010683d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106842:	e9 42 f6 ff ff       	jmp    80105e89 <alltraps>

80106847 <vector141>:
.globl vector141
vector141:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $141
80106849:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010684e:	e9 36 f6 ff ff       	jmp    80105e89 <alltraps>

80106853 <vector142>:
.globl vector142
vector142:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $142
80106855:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010685a:	e9 2a f6 ff ff       	jmp    80105e89 <alltraps>

8010685f <vector143>:
.globl vector143
vector143:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $143
80106861:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106866:	e9 1e f6 ff ff       	jmp    80105e89 <alltraps>

8010686b <vector144>:
.globl vector144
vector144:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $144
8010686d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106872:	e9 12 f6 ff ff       	jmp    80105e89 <alltraps>

80106877 <vector145>:
.globl vector145
vector145:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $145
80106879:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010687e:	e9 06 f6 ff ff       	jmp    80105e89 <alltraps>

80106883 <vector146>:
.globl vector146
vector146:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $146
80106885:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010688a:	e9 fa f5 ff ff       	jmp    80105e89 <alltraps>

8010688f <vector147>:
.globl vector147
vector147:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $147
80106891:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106896:	e9 ee f5 ff ff       	jmp    80105e89 <alltraps>

8010689b <vector148>:
.globl vector148
vector148:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $148
8010689d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801068a2:	e9 e2 f5 ff ff       	jmp    80105e89 <alltraps>

801068a7 <vector149>:
.globl vector149
vector149:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $149
801068a9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801068ae:	e9 d6 f5 ff ff       	jmp    80105e89 <alltraps>

801068b3 <vector150>:
.globl vector150
vector150:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $150
801068b5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801068ba:	e9 ca f5 ff ff       	jmp    80105e89 <alltraps>

801068bf <vector151>:
.globl vector151
vector151:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $151
801068c1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801068c6:	e9 be f5 ff ff       	jmp    80105e89 <alltraps>

801068cb <vector152>:
.globl vector152
vector152:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $152
801068cd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801068d2:	e9 b2 f5 ff ff       	jmp    80105e89 <alltraps>

801068d7 <vector153>:
.globl vector153
vector153:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $153
801068d9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801068de:	e9 a6 f5 ff ff       	jmp    80105e89 <alltraps>

801068e3 <vector154>:
.globl vector154
vector154:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $154
801068e5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801068ea:	e9 9a f5 ff ff       	jmp    80105e89 <alltraps>

801068ef <vector155>:
.globl vector155
vector155:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $155
801068f1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801068f6:	e9 8e f5 ff ff       	jmp    80105e89 <alltraps>

801068fb <vector156>:
.globl vector156
vector156:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $156
801068fd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106902:	e9 82 f5 ff ff       	jmp    80105e89 <alltraps>

80106907 <vector157>:
.globl vector157
vector157:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $157
80106909:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010690e:	e9 76 f5 ff ff       	jmp    80105e89 <alltraps>

80106913 <vector158>:
.globl vector158
vector158:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $158
80106915:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010691a:	e9 6a f5 ff ff       	jmp    80105e89 <alltraps>

8010691f <vector159>:
.globl vector159
vector159:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $159
80106921:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106926:	e9 5e f5 ff ff       	jmp    80105e89 <alltraps>

8010692b <vector160>:
.globl vector160
vector160:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $160
8010692d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106932:	e9 52 f5 ff ff       	jmp    80105e89 <alltraps>

80106937 <vector161>:
.globl vector161
vector161:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $161
80106939:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010693e:	e9 46 f5 ff ff       	jmp    80105e89 <alltraps>

80106943 <vector162>:
.globl vector162
vector162:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $162
80106945:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010694a:	e9 3a f5 ff ff       	jmp    80105e89 <alltraps>

8010694f <vector163>:
.globl vector163
vector163:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $163
80106951:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106956:	e9 2e f5 ff ff       	jmp    80105e89 <alltraps>

8010695b <vector164>:
.globl vector164
vector164:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $164
8010695d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106962:	e9 22 f5 ff ff       	jmp    80105e89 <alltraps>

80106967 <vector165>:
.globl vector165
vector165:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $165
80106969:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010696e:	e9 16 f5 ff ff       	jmp    80105e89 <alltraps>

80106973 <vector166>:
.globl vector166
vector166:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $166
80106975:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010697a:	e9 0a f5 ff ff       	jmp    80105e89 <alltraps>

8010697f <vector167>:
.globl vector167
vector167:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $167
80106981:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106986:	e9 fe f4 ff ff       	jmp    80105e89 <alltraps>

8010698b <vector168>:
.globl vector168
vector168:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $168
8010698d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106992:	e9 f2 f4 ff ff       	jmp    80105e89 <alltraps>

80106997 <vector169>:
.globl vector169
vector169:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $169
80106999:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010699e:	e9 e6 f4 ff ff       	jmp    80105e89 <alltraps>

801069a3 <vector170>:
.globl vector170
vector170:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $170
801069a5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801069aa:	e9 da f4 ff ff       	jmp    80105e89 <alltraps>

801069af <vector171>:
.globl vector171
vector171:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $171
801069b1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801069b6:	e9 ce f4 ff ff       	jmp    80105e89 <alltraps>

801069bb <vector172>:
.globl vector172
vector172:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $172
801069bd:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801069c2:	e9 c2 f4 ff ff       	jmp    80105e89 <alltraps>

801069c7 <vector173>:
.globl vector173
vector173:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $173
801069c9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801069ce:	e9 b6 f4 ff ff       	jmp    80105e89 <alltraps>

801069d3 <vector174>:
.globl vector174
vector174:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $174
801069d5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801069da:	e9 aa f4 ff ff       	jmp    80105e89 <alltraps>

801069df <vector175>:
.globl vector175
vector175:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $175
801069e1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801069e6:	e9 9e f4 ff ff       	jmp    80105e89 <alltraps>

801069eb <vector176>:
.globl vector176
vector176:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $176
801069ed:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801069f2:	e9 92 f4 ff ff       	jmp    80105e89 <alltraps>

801069f7 <vector177>:
.globl vector177
vector177:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $177
801069f9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801069fe:	e9 86 f4 ff ff       	jmp    80105e89 <alltraps>

80106a03 <vector178>:
.globl vector178
vector178:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $178
80106a05:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106a0a:	e9 7a f4 ff ff       	jmp    80105e89 <alltraps>

80106a0f <vector179>:
.globl vector179
vector179:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $179
80106a11:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106a16:	e9 6e f4 ff ff       	jmp    80105e89 <alltraps>

80106a1b <vector180>:
.globl vector180
vector180:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $180
80106a1d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106a22:	e9 62 f4 ff ff       	jmp    80105e89 <alltraps>

80106a27 <vector181>:
.globl vector181
vector181:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $181
80106a29:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106a2e:	e9 56 f4 ff ff       	jmp    80105e89 <alltraps>

80106a33 <vector182>:
.globl vector182
vector182:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $182
80106a35:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106a3a:	e9 4a f4 ff ff       	jmp    80105e89 <alltraps>

80106a3f <vector183>:
.globl vector183
vector183:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $183
80106a41:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106a46:	e9 3e f4 ff ff       	jmp    80105e89 <alltraps>

80106a4b <vector184>:
.globl vector184
vector184:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $184
80106a4d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106a52:	e9 32 f4 ff ff       	jmp    80105e89 <alltraps>

80106a57 <vector185>:
.globl vector185
vector185:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $185
80106a59:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106a5e:	e9 26 f4 ff ff       	jmp    80105e89 <alltraps>

80106a63 <vector186>:
.globl vector186
vector186:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $186
80106a65:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106a6a:	e9 1a f4 ff ff       	jmp    80105e89 <alltraps>

80106a6f <vector187>:
.globl vector187
vector187:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $187
80106a71:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106a76:	e9 0e f4 ff ff       	jmp    80105e89 <alltraps>

80106a7b <vector188>:
.globl vector188
vector188:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $188
80106a7d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106a82:	e9 02 f4 ff ff       	jmp    80105e89 <alltraps>

80106a87 <vector189>:
.globl vector189
vector189:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $189
80106a89:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106a8e:	e9 f6 f3 ff ff       	jmp    80105e89 <alltraps>

80106a93 <vector190>:
.globl vector190
vector190:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $190
80106a95:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a9a:	e9 ea f3 ff ff       	jmp    80105e89 <alltraps>

80106a9f <vector191>:
.globl vector191
vector191:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $191
80106aa1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106aa6:	e9 de f3 ff ff       	jmp    80105e89 <alltraps>

80106aab <vector192>:
.globl vector192
vector192:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $192
80106aad:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106ab2:	e9 d2 f3 ff ff       	jmp    80105e89 <alltraps>

80106ab7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $193
80106ab9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106abe:	e9 c6 f3 ff ff       	jmp    80105e89 <alltraps>

80106ac3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $194
80106ac5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106aca:	e9 ba f3 ff ff       	jmp    80105e89 <alltraps>

80106acf <vector195>:
.globl vector195
vector195:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $195
80106ad1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ad6:	e9 ae f3 ff ff       	jmp    80105e89 <alltraps>

80106adb <vector196>:
.globl vector196
vector196:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $196
80106add:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106ae2:	e9 a2 f3 ff ff       	jmp    80105e89 <alltraps>

80106ae7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $197
80106ae9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106aee:	e9 96 f3 ff ff       	jmp    80105e89 <alltraps>

80106af3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $198
80106af5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106afa:	e9 8a f3 ff ff       	jmp    80105e89 <alltraps>

80106aff <vector199>:
.globl vector199
vector199:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $199
80106b01:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106b06:	e9 7e f3 ff ff       	jmp    80105e89 <alltraps>

80106b0b <vector200>:
.globl vector200
vector200:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $200
80106b0d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106b12:	e9 72 f3 ff ff       	jmp    80105e89 <alltraps>

80106b17 <vector201>:
.globl vector201
vector201:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $201
80106b19:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106b1e:	e9 66 f3 ff ff       	jmp    80105e89 <alltraps>

80106b23 <vector202>:
.globl vector202
vector202:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $202
80106b25:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106b2a:	e9 5a f3 ff ff       	jmp    80105e89 <alltraps>

80106b2f <vector203>:
.globl vector203
vector203:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $203
80106b31:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106b36:	e9 4e f3 ff ff       	jmp    80105e89 <alltraps>

80106b3b <vector204>:
.globl vector204
vector204:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $204
80106b3d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106b42:	e9 42 f3 ff ff       	jmp    80105e89 <alltraps>

80106b47 <vector205>:
.globl vector205
vector205:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $205
80106b49:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106b4e:	e9 36 f3 ff ff       	jmp    80105e89 <alltraps>

80106b53 <vector206>:
.globl vector206
vector206:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $206
80106b55:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106b5a:	e9 2a f3 ff ff       	jmp    80105e89 <alltraps>

80106b5f <vector207>:
.globl vector207
vector207:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $207
80106b61:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106b66:	e9 1e f3 ff ff       	jmp    80105e89 <alltraps>

80106b6b <vector208>:
.globl vector208
vector208:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $208
80106b6d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106b72:	e9 12 f3 ff ff       	jmp    80105e89 <alltraps>

80106b77 <vector209>:
.globl vector209
vector209:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $209
80106b79:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106b7e:	e9 06 f3 ff ff       	jmp    80105e89 <alltraps>

80106b83 <vector210>:
.globl vector210
vector210:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $210
80106b85:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106b8a:	e9 fa f2 ff ff       	jmp    80105e89 <alltraps>

80106b8f <vector211>:
.globl vector211
vector211:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $211
80106b91:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b96:	e9 ee f2 ff ff       	jmp    80105e89 <alltraps>

80106b9b <vector212>:
.globl vector212
vector212:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $212
80106b9d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ba2:	e9 e2 f2 ff ff       	jmp    80105e89 <alltraps>

80106ba7 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $213
80106ba9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106bae:	e9 d6 f2 ff ff       	jmp    80105e89 <alltraps>

80106bb3 <vector214>:
.globl vector214
vector214:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $214
80106bb5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106bba:	e9 ca f2 ff ff       	jmp    80105e89 <alltraps>

80106bbf <vector215>:
.globl vector215
vector215:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $215
80106bc1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106bc6:	e9 be f2 ff ff       	jmp    80105e89 <alltraps>

80106bcb <vector216>:
.globl vector216
vector216:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $216
80106bcd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106bd2:	e9 b2 f2 ff ff       	jmp    80105e89 <alltraps>

80106bd7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $217
80106bd9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106bde:	e9 a6 f2 ff ff       	jmp    80105e89 <alltraps>

80106be3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $218
80106be5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106bea:	e9 9a f2 ff ff       	jmp    80105e89 <alltraps>

80106bef <vector219>:
.globl vector219
vector219:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $219
80106bf1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106bf6:	e9 8e f2 ff ff       	jmp    80105e89 <alltraps>

80106bfb <vector220>:
.globl vector220
vector220:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $220
80106bfd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c02:	e9 82 f2 ff ff       	jmp    80105e89 <alltraps>

80106c07 <vector221>:
.globl vector221
vector221:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $221
80106c09:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106c0e:	e9 76 f2 ff ff       	jmp    80105e89 <alltraps>

80106c13 <vector222>:
.globl vector222
vector222:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $222
80106c15:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106c1a:	e9 6a f2 ff ff       	jmp    80105e89 <alltraps>

80106c1f <vector223>:
.globl vector223
vector223:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $223
80106c21:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106c26:	e9 5e f2 ff ff       	jmp    80105e89 <alltraps>

80106c2b <vector224>:
.globl vector224
vector224:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $224
80106c2d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106c32:	e9 52 f2 ff ff       	jmp    80105e89 <alltraps>

80106c37 <vector225>:
.globl vector225
vector225:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $225
80106c39:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106c3e:	e9 46 f2 ff ff       	jmp    80105e89 <alltraps>

80106c43 <vector226>:
.globl vector226
vector226:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $226
80106c45:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106c4a:	e9 3a f2 ff ff       	jmp    80105e89 <alltraps>

80106c4f <vector227>:
.globl vector227
vector227:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $227
80106c51:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106c56:	e9 2e f2 ff ff       	jmp    80105e89 <alltraps>

80106c5b <vector228>:
.globl vector228
vector228:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $228
80106c5d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106c62:	e9 22 f2 ff ff       	jmp    80105e89 <alltraps>

80106c67 <vector229>:
.globl vector229
vector229:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $229
80106c69:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106c6e:	e9 16 f2 ff ff       	jmp    80105e89 <alltraps>

80106c73 <vector230>:
.globl vector230
vector230:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $230
80106c75:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106c7a:	e9 0a f2 ff ff       	jmp    80105e89 <alltraps>

80106c7f <vector231>:
.globl vector231
vector231:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $231
80106c81:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106c86:	e9 fe f1 ff ff       	jmp    80105e89 <alltraps>

80106c8b <vector232>:
.globl vector232
vector232:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $232
80106c8d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106c92:	e9 f2 f1 ff ff       	jmp    80105e89 <alltraps>

80106c97 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $233
80106c99:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c9e:	e9 e6 f1 ff ff       	jmp    80105e89 <alltraps>

80106ca3 <vector234>:
.globl vector234
vector234:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $234
80106ca5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106caa:	e9 da f1 ff ff       	jmp    80105e89 <alltraps>

80106caf <vector235>:
.globl vector235
vector235:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $235
80106cb1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106cb6:	e9 ce f1 ff ff       	jmp    80105e89 <alltraps>

80106cbb <vector236>:
.globl vector236
vector236:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $236
80106cbd:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106cc2:	e9 c2 f1 ff ff       	jmp    80105e89 <alltraps>

80106cc7 <vector237>:
.globl vector237
vector237:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $237
80106cc9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106cce:	e9 b6 f1 ff ff       	jmp    80105e89 <alltraps>

80106cd3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $238
80106cd5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106cda:	e9 aa f1 ff ff       	jmp    80105e89 <alltraps>

80106cdf <vector239>:
.globl vector239
vector239:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $239
80106ce1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ce6:	e9 9e f1 ff ff       	jmp    80105e89 <alltraps>

80106ceb <vector240>:
.globl vector240
vector240:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $240
80106ced:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106cf2:	e9 92 f1 ff ff       	jmp    80105e89 <alltraps>

80106cf7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $241
80106cf9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106cfe:	e9 86 f1 ff ff       	jmp    80105e89 <alltraps>

80106d03 <vector242>:
.globl vector242
vector242:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $242
80106d05:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106d0a:	e9 7a f1 ff ff       	jmp    80105e89 <alltraps>

80106d0f <vector243>:
.globl vector243
vector243:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $243
80106d11:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106d16:	e9 6e f1 ff ff       	jmp    80105e89 <alltraps>

80106d1b <vector244>:
.globl vector244
vector244:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $244
80106d1d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106d22:	e9 62 f1 ff ff       	jmp    80105e89 <alltraps>

80106d27 <vector245>:
.globl vector245
vector245:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $245
80106d29:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106d2e:	e9 56 f1 ff ff       	jmp    80105e89 <alltraps>

80106d33 <vector246>:
.globl vector246
vector246:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $246
80106d35:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106d3a:	e9 4a f1 ff ff       	jmp    80105e89 <alltraps>

80106d3f <vector247>:
.globl vector247
vector247:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $247
80106d41:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106d46:	e9 3e f1 ff ff       	jmp    80105e89 <alltraps>

80106d4b <vector248>:
.globl vector248
vector248:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $248
80106d4d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106d52:	e9 32 f1 ff ff       	jmp    80105e89 <alltraps>

80106d57 <vector249>:
.globl vector249
vector249:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $249
80106d59:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106d5e:	e9 26 f1 ff ff       	jmp    80105e89 <alltraps>

80106d63 <vector250>:
.globl vector250
vector250:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $250
80106d65:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106d6a:	e9 1a f1 ff ff       	jmp    80105e89 <alltraps>

80106d6f <vector251>:
.globl vector251
vector251:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $251
80106d71:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106d76:	e9 0e f1 ff ff       	jmp    80105e89 <alltraps>

80106d7b <vector252>:
.globl vector252
vector252:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $252
80106d7d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106d82:	e9 02 f1 ff ff       	jmp    80105e89 <alltraps>

80106d87 <vector253>:
.globl vector253
vector253:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $253
80106d89:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106d8e:	e9 f6 f0 ff ff       	jmp    80105e89 <alltraps>

80106d93 <vector254>:
.globl vector254
vector254:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $254
80106d95:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d9a:	e9 ea f0 ff ff       	jmp    80105e89 <alltraps>

80106d9f <vector255>:
.globl vector255
vector255:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $255
80106da1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106da6:	e9 de f0 ff ff       	jmp    80105e89 <alltraps>
80106dab:	66 90                	xchg   %ax,%ax
80106dad:	66 90                	xchg   %ax,%ax
80106daf:	90                   	nop

80106db0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	57                   	push   %edi
80106db4:	56                   	push   %esi
80106db5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106db7:	c1 ea 16             	shr    $0x16,%edx
{
80106dba:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
80106dbb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
80106dbe:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106dc1:	8b 1f                	mov    (%edi),%ebx
80106dc3:	f6 c3 01             	test   $0x1,%bl
80106dc6:	74 28                	je     80106df0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106dc8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106dce:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106dd4:	89 f0                	mov    %esi,%eax
}
80106dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106dd9:	c1 e8 0a             	shr    $0xa,%eax
80106ddc:	25 fc 0f 00 00       	and    $0xffc,%eax
80106de1:	01 d8                	add    %ebx,%eax
}
80106de3:	5b                   	pop    %ebx
80106de4:	5e                   	pop    %esi
80106de5:	5f                   	pop    %edi
80106de6:	5d                   	pop    %ebp
80106de7:	c3                   	ret    
80106de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106def:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106df0:	85 c9                	test   %ecx,%ecx
80106df2:	74 2c                	je     80106e20 <walkpgdir+0x70>
80106df4:	e8 57 b8 ff ff       	call   80102650 <kalloc>
80106df9:	89 c3                	mov    %eax,%ebx
80106dfb:	85 c0                	test   %eax,%eax
80106dfd:	74 21                	je     80106e20 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106dff:	83 ec 04             	sub    $0x4,%esp
80106e02:	68 00 10 00 00       	push   $0x1000
80106e07:	6a 00                	push   $0x0
80106e09:	50                   	push   %eax
80106e0a:	e8 e1 dd ff ff       	call   80104bf0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e0f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e15:	83 c4 10             	add    $0x10,%esp
80106e18:	83 c8 07             	or     $0x7,%eax
80106e1b:	89 07                	mov    %eax,(%edi)
80106e1d:	eb b5                	jmp    80106dd4 <walkpgdir+0x24>
80106e1f:	90                   	nop
}
80106e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106e23:	31 c0                	xor    %eax,%eax
}
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5f                   	pop    %edi
80106e28:	5d                   	pop    %ebp
80106e29:	c3                   	ret    
80106e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e30 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	57                   	push   %edi
80106e34:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e36:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
80106e3a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80106e40:	89 d6                	mov    %edx,%esi
{
80106e42:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106e43:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80106e49:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106e4c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80106e52:	29 f0                	sub    %esi,%eax
80106e54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e57:	eb 1f                	jmp    80106e78 <mappages+0x48>
80106e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106e60:	f6 00 01             	testb  $0x1,(%eax)
80106e63:	75 45                	jne    80106eaa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106e65:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106e68:	83 cb 01             	or     $0x1,%ebx
80106e6b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
80106e6d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106e70:	74 2e                	je     80106ea0 <mappages+0x70>
      break;
    a += PGSIZE;
80106e72:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e7b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106e80:	89 f2                	mov    %esi,%edx
80106e82:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106e85:	89 f8                	mov    %edi,%eax
80106e87:	e8 24 ff ff ff       	call   80106db0 <walkpgdir>
80106e8c:	85 c0                	test   %eax,%eax
80106e8e:	75 d0                	jne    80106e60 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e98:	5b                   	pop    %ebx
80106e99:	5e                   	pop    %esi
80106e9a:	5f                   	pop    %edi
80106e9b:	5d                   	pop    %ebp
80106e9c:	c3                   	ret    
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi
80106ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ea3:	31 c0                	xor    %eax,%eax
}
80106ea5:	5b                   	pop    %ebx
80106ea6:	5e                   	pop    %esi
80106ea7:	5f                   	pop    %edi
80106ea8:	5d                   	pop    %ebp
80106ea9:	c3                   	ret    
      panic("remap");
80106eaa:	83 ec 0c             	sub    $0xc,%esp
80106ead:	68 d8 7f 10 80       	push   $0x80107fd8
80106eb2:	e8 d9 94 ff ff       	call   80100390 <panic>
80106eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebe:	66 90                	xchg   %ax,%ax

80106ec0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	89 c6                	mov    %eax,%esi
80106ec7:	53                   	push   %ebx
80106ec8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106eca:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106ed0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
80106ed9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106edc:	39 da                	cmp    %ebx,%edx
80106ede:	73 5b                	jae    80106f3b <deallocuvm.part.0+0x7b>
80106ee0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106ee3:	89 d7                	mov    %edx,%edi
80106ee5:	eb 14                	jmp    80106efb <deallocuvm.part.0+0x3b>
80106ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106eee:	66 90                	xchg   %ax,%ax
80106ef0:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106ef6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106ef9:	76 40                	jbe    80106f3b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106efb:	31 c9                	xor    %ecx,%ecx
80106efd:	89 fa                	mov    %edi,%edx
80106eff:	89 f0                	mov    %esi,%eax
80106f01:	e8 aa fe ff ff       	call   80106db0 <walkpgdir>
80106f06:	89 c3                	mov    %eax,%ebx
    if(!pte)
80106f08:	85 c0                	test   %eax,%eax
80106f0a:	74 44                	je     80106f50 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106f0c:	8b 00                	mov    (%eax),%eax
80106f0e:	a8 01                	test   $0x1,%al
80106f10:	74 de                	je     80106ef0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106f12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f17:	74 47                	je     80106f60 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106f19:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106f1c:	05 00 00 00 80       	add    $0x80000000,%eax
80106f21:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80106f27:	50                   	push   %eax
80106f28:	e8 63 b5 ff ff       	call   80102490 <kfree>
      *pte = 0;
80106f2d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80106f33:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80106f36:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106f39:	77 c0                	ja     80106efb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
80106f3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f41:	5b                   	pop    %ebx
80106f42:	5e                   	pop    %esi
80106f43:	5f                   	pop    %edi
80106f44:	5d                   	pop    %ebp
80106f45:	c3                   	ret    
80106f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f4d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f50:	89 fa                	mov    %edi,%edx
80106f52:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80106f58:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
80106f5e:	eb 96                	jmp    80106ef6 <deallocuvm.part.0+0x36>
        panic("kfree");
80106f60:	83 ec 0c             	sub    $0xc,%esp
80106f63:	68 66 79 10 80       	push   $0x80107966
80106f68:	e8 23 94 ff ff       	call   80100390 <panic>
80106f6d:	8d 76 00             	lea    0x0(%esi),%esi

80106f70 <seginit>:
{
80106f70:	f3 0f 1e fb          	endbr32 
80106f74:	55                   	push   %ebp
80106f75:	89 e5                	mov    %esp,%ebp
80106f77:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f7a:	e8 11 ca ff ff       	call   80103990 <cpuid>
  pd[0] = size-1;
80106f7f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f84:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106f8a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f8e:	c7 80 18 38 11 80 ff 	movl   $0xffff,-0x7feec7e8(%eax)
80106f95:	ff 00 00 
80106f98:	c7 80 1c 38 11 80 00 	movl   $0xcf9a00,-0x7feec7e4(%eax)
80106f9f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106fa2:	c7 80 20 38 11 80 ff 	movl   $0xffff,-0x7feec7e0(%eax)
80106fa9:	ff 00 00 
80106fac:	c7 80 24 38 11 80 00 	movl   $0xcf9200,-0x7feec7dc(%eax)
80106fb3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106fb6:	c7 80 28 38 11 80 ff 	movl   $0xffff,-0x7feec7d8(%eax)
80106fbd:	ff 00 00 
80106fc0:	c7 80 2c 38 11 80 00 	movl   $0xcffa00,-0x7feec7d4(%eax)
80106fc7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106fca:	c7 80 30 38 11 80 ff 	movl   $0xffff,-0x7feec7d0(%eax)
80106fd1:	ff 00 00 
80106fd4:	c7 80 34 38 11 80 00 	movl   $0xcff200,-0x7feec7cc(%eax)
80106fdb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106fde:	05 10 38 11 80       	add    $0x80113810,%eax
  pd[1] = (uint)p;
80106fe3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106fe7:	c1 e8 10             	shr    $0x10,%eax
80106fea:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106fee:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ff1:	0f 01 10             	lgdtl  (%eax)
}
80106ff4:	c9                   	leave  
80106ff5:	c3                   	ret    
80106ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ffd:	8d 76 00             	lea    0x0(%esi),%esi

80107000 <switchkvm>:
{
80107000:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107004:	a1 04 68 11 80       	mov    0x80116804,%eax
80107009:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010700e:	0f 22 d8             	mov    %eax,%cr3
}
80107011:	c3                   	ret    
80107012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107020 <switchuvm>:
{
80107020:	f3 0f 1e fb          	endbr32 
80107024:	55                   	push   %ebp
80107025:	89 e5                	mov    %esp,%ebp
80107027:	57                   	push   %edi
80107028:	56                   	push   %esi
80107029:	53                   	push   %ebx
8010702a:	83 ec 1c             	sub    $0x1c,%esp
8010702d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107030:	85 f6                	test   %esi,%esi
80107032:	0f 84 cb 00 00 00    	je     80107103 <switchuvm+0xe3>
  if(p->kstack == 0)
80107038:	8b 46 08             	mov    0x8(%esi),%eax
8010703b:	85 c0                	test   %eax,%eax
8010703d:	0f 84 da 00 00 00    	je     8010711d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107043:	8b 46 04             	mov    0x4(%esi),%eax
80107046:	85 c0                	test   %eax,%eax
80107048:	0f 84 c2 00 00 00    	je     80107110 <switchuvm+0xf0>
  pushcli();
8010704e:	e8 8d d9 ff ff       	call   801049e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107053:	e8 c8 c8 ff ff       	call   80103920 <mycpu>
80107058:	89 c3                	mov    %eax,%ebx
8010705a:	e8 c1 c8 ff ff       	call   80103920 <mycpu>
8010705f:	89 c7                	mov    %eax,%edi
80107061:	e8 ba c8 ff ff       	call   80103920 <mycpu>
80107066:	83 c7 08             	add    $0x8,%edi
80107069:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010706c:	e8 af c8 ff ff       	call   80103920 <mycpu>
80107071:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107074:	ba 67 00 00 00       	mov    $0x67,%edx
80107079:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107080:	83 c0 08             	add    $0x8,%eax
80107083:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010708a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010708f:	83 c1 08             	add    $0x8,%ecx
80107092:	c1 e8 18             	shr    $0x18,%eax
80107095:	c1 e9 10             	shr    $0x10,%ecx
80107098:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010709e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801070a4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801070a9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070b0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801070b5:	e8 66 c8 ff ff       	call   80103920 <mycpu>
801070ba:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070c1:	e8 5a c8 ff ff       	call   80103920 <mycpu>
801070c6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801070ca:	8b 5e 08             	mov    0x8(%esi),%ebx
801070cd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070d3:	e8 48 c8 ff ff       	call   80103920 <mycpu>
801070d8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070db:	e8 40 c8 ff ff       	call   80103920 <mycpu>
801070e0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801070e4:	b8 28 00 00 00       	mov    $0x28,%eax
801070e9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801070ec:	8b 46 04             	mov    0x4(%esi),%eax
801070ef:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070f4:	0f 22 d8             	mov    %eax,%cr3
}
801070f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070fa:	5b                   	pop    %ebx
801070fb:	5e                   	pop    %esi
801070fc:	5f                   	pop    %edi
801070fd:	5d                   	pop    %ebp
  popcli();
801070fe:	e9 2d d9 ff ff       	jmp    80104a30 <popcli>
    panic("switchuvm: no process");
80107103:	83 ec 0c             	sub    $0xc,%esp
80107106:	68 de 7f 10 80       	push   $0x80107fde
8010710b:	e8 80 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107110:	83 ec 0c             	sub    $0xc,%esp
80107113:	68 09 80 10 80       	push   $0x80108009
80107118:	e8 73 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010711d:	83 ec 0c             	sub    $0xc,%esp
80107120:	68 f4 7f 10 80       	push   $0x80107ff4
80107125:	e8 66 92 ff ff       	call   80100390 <panic>
8010712a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107130 <inituvm>:
{
80107130:	f3 0f 1e fb          	endbr32 
80107134:	55                   	push   %ebp
80107135:	89 e5                	mov    %esp,%ebp
80107137:	57                   	push   %edi
80107138:	56                   	push   %esi
80107139:	53                   	push   %ebx
8010713a:	83 ec 1c             	sub    $0x1c,%esp
8010713d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107140:	8b 75 10             	mov    0x10(%ebp),%esi
80107143:	8b 7d 08             	mov    0x8(%ebp),%edi
80107146:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107149:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010714f:	77 4b                	ja     8010719c <inituvm+0x6c>
  mem = kalloc();
80107151:	e8 fa b4 ff ff       	call   80102650 <kalloc>
  memset(mem, 0, PGSIZE);
80107156:	83 ec 04             	sub    $0x4,%esp
80107159:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010715e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107160:	6a 00                	push   $0x0
80107162:	50                   	push   %eax
80107163:	e8 88 da ff ff       	call   80104bf0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107168:	58                   	pop    %eax
80107169:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010716f:	5a                   	pop    %edx
80107170:	6a 06                	push   $0x6
80107172:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107177:	31 d2                	xor    %edx,%edx
80107179:	50                   	push   %eax
8010717a:	89 f8                	mov    %edi,%eax
8010717c:	e8 af fc ff ff       	call   80106e30 <mappages>
  memmove(mem, init, sz);
80107181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107184:	89 75 10             	mov    %esi,0x10(%ebp)
80107187:	83 c4 10             	add    $0x10,%esp
8010718a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010718d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107193:	5b                   	pop    %ebx
80107194:	5e                   	pop    %esi
80107195:	5f                   	pop    %edi
80107196:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107197:	e9 f4 da ff ff       	jmp    80104c90 <memmove>
    panic("inituvm: more than a page");
8010719c:	83 ec 0c             	sub    $0xc,%esp
8010719f:	68 1d 80 10 80       	push   $0x8010801d
801071a4:	e8 e7 91 ff ff       	call   80100390 <panic>
801071a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071b0 <loaduvm>:
{
801071b0:	f3 0f 1e fb          	endbr32 
801071b4:	55                   	push   %ebp
801071b5:	89 e5                	mov    %esp,%ebp
801071b7:	57                   	push   %edi
801071b8:	56                   	push   %esi
801071b9:	53                   	push   %ebx
801071ba:	83 ec 1c             	sub    $0x1c,%esp
801071bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801071c0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801071c3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801071c8:	0f 85 99 00 00 00    	jne    80107267 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801071ce:	01 f0                	add    %esi,%eax
801071d0:	89 f3                	mov    %esi,%ebx
801071d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801071d5:	8b 45 14             	mov    0x14(%ebp),%eax
801071d8:	01 f0                	add    %esi,%eax
801071da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801071dd:	85 f6                	test   %esi,%esi
801071df:	75 15                	jne    801071f6 <loaduvm+0x46>
801071e1:	eb 6d                	jmp    80107250 <loaduvm+0xa0>
801071e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801071e7:	90                   	nop
801071e8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801071ee:	89 f0                	mov    %esi,%eax
801071f0:	29 d8                	sub    %ebx,%eax
801071f2:	39 c6                	cmp    %eax,%esi
801071f4:	76 5a                	jbe    80107250 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801071f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071f9:	8b 45 08             	mov    0x8(%ebp),%eax
801071fc:	31 c9                	xor    %ecx,%ecx
801071fe:	29 da                	sub    %ebx,%edx
80107200:	e8 ab fb ff ff       	call   80106db0 <walkpgdir>
80107205:	85 c0                	test   %eax,%eax
80107207:	74 51                	je     8010725a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107209:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010720b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010720e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107213:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107218:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010721e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107221:	29 d9                	sub    %ebx,%ecx
80107223:	05 00 00 00 80       	add    $0x80000000,%eax
80107228:	57                   	push   %edi
80107229:	51                   	push   %ecx
8010722a:	50                   	push   %eax
8010722b:	ff 75 10             	pushl  0x10(%ebp)
8010722e:	e8 4d a8 ff ff       	call   80101a80 <readi>
80107233:	83 c4 10             	add    $0x10,%esp
80107236:	39 f8                	cmp    %edi,%eax
80107238:	74 ae                	je     801071e8 <loaduvm+0x38>
}
8010723a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010723d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107242:	5b                   	pop    %ebx
80107243:	5e                   	pop    %esi
80107244:	5f                   	pop    %edi
80107245:	5d                   	pop    %ebp
80107246:	c3                   	ret    
80107247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010724e:	66 90                	xchg   %ax,%ax
80107250:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107253:	31 c0                	xor    %eax,%eax
}
80107255:	5b                   	pop    %ebx
80107256:	5e                   	pop    %esi
80107257:	5f                   	pop    %edi
80107258:	5d                   	pop    %ebp
80107259:	c3                   	ret    
      panic("loaduvm: address should exist");
8010725a:	83 ec 0c             	sub    $0xc,%esp
8010725d:	68 37 80 10 80       	push   $0x80108037
80107262:	e8 29 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107267:	83 ec 0c             	sub    $0xc,%esp
8010726a:	68 d8 80 10 80       	push   $0x801080d8
8010726f:	e8 1c 91 ff ff       	call   80100390 <panic>
80107274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010727b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010727f:	90                   	nop

80107280 <allocuvm>:
{
80107280:	f3 0f 1e fb          	endbr32 
80107284:	55                   	push   %ebp
80107285:	89 e5                	mov    %esp,%ebp
80107287:	57                   	push   %edi
80107288:	56                   	push   %esi
80107289:	53                   	push   %ebx
8010728a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010728d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107290:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107293:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107296:	85 c0                	test   %eax,%eax
80107298:	0f 88 b2 00 00 00    	js     80107350 <allocuvm+0xd0>
  if(newsz < oldsz)
8010729e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801072a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801072a4:	0f 82 96 00 00 00    	jb     80107340 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801072aa:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801072b0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801072b6:	39 75 10             	cmp    %esi,0x10(%ebp)
801072b9:	77 40                	ja     801072fb <allocuvm+0x7b>
801072bb:	e9 83 00 00 00       	jmp    80107343 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801072c0:	83 ec 04             	sub    $0x4,%esp
801072c3:	68 00 10 00 00       	push   $0x1000
801072c8:	6a 00                	push   $0x0
801072ca:	50                   	push   %eax
801072cb:	e8 20 d9 ff ff       	call   80104bf0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801072d0:	58                   	pop    %eax
801072d1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072d7:	5a                   	pop    %edx
801072d8:	6a 06                	push   $0x6
801072da:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072df:	89 f2                	mov    %esi,%edx
801072e1:	50                   	push   %eax
801072e2:	89 f8                	mov    %edi,%eax
801072e4:	e8 47 fb ff ff       	call   80106e30 <mappages>
801072e9:	83 c4 10             	add    $0x10,%esp
801072ec:	85 c0                	test   %eax,%eax
801072ee:	78 78                	js     80107368 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801072f0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072f6:	39 75 10             	cmp    %esi,0x10(%ebp)
801072f9:	76 48                	jbe    80107343 <allocuvm+0xc3>
    mem = kalloc();
801072fb:	e8 50 b3 ff ff       	call   80102650 <kalloc>
80107300:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107302:	85 c0                	test   %eax,%eax
80107304:	75 ba                	jne    801072c0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107306:	83 ec 0c             	sub    $0xc,%esp
80107309:	68 55 80 10 80       	push   $0x80108055
8010730e:	e8 9d 93 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107313:	8b 45 0c             	mov    0xc(%ebp),%eax
80107316:	83 c4 10             	add    $0x10,%esp
80107319:	39 45 10             	cmp    %eax,0x10(%ebp)
8010731c:	74 32                	je     80107350 <allocuvm+0xd0>
8010731e:	8b 55 10             	mov    0x10(%ebp),%edx
80107321:	89 c1                	mov    %eax,%ecx
80107323:	89 f8                	mov    %edi,%eax
80107325:	e8 96 fb ff ff       	call   80106ec0 <deallocuvm.part.0>
      return 0;
8010732a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107331:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107334:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107337:	5b                   	pop    %ebx
80107338:	5e                   	pop    %esi
80107339:	5f                   	pop    %edi
8010733a:	5d                   	pop    %ebp
8010733b:	c3                   	ret    
8010733c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107340:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107343:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107346:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107349:	5b                   	pop    %ebx
8010734a:	5e                   	pop    %esi
8010734b:	5f                   	pop    %edi
8010734c:	5d                   	pop    %ebp
8010734d:	c3                   	ret    
8010734e:	66 90                	xchg   %ax,%ax
    return 0;
80107350:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010735a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010735d:	5b                   	pop    %ebx
8010735e:	5e                   	pop    %esi
8010735f:	5f                   	pop    %edi
80107360:	5d                   	pop    %ebp
80107361:	c3                   	ret    
80107362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107368:	83 ec 0c             	sub    $0xc,%esp
8010736b:	68 6d 80 10 80       	push   $0x8010806d
80107370:	e8 3b 93 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107375:	8b 45 0c             	mov    0xc(%ebp),%eax
80107378:	83 c4 10             	add    $0x10,%esp
8010737b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010737e:	74 0c                	je     8010738c <allocuvm+0x10c>
80107380:	8b 55 10             	mov    0x10(%ebp),%edx
80107383:	89 c1                	mov    %eax,%ecx
80107385:	89 f8                	mov    %edi,%eax
80107387:	e8 34 fb ff ff       	call   80106ec0 <deallocuvm.part.0>
      kfree(mem);
8010738c:	83 ec 0c             	sub    $0xc,%esp
8010738f:	53                   	push   %ebx
80107390:	e8 fb b0 ff ff       	call   80102490 <kfree>
      return 0;
80107395:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010739c:	83 c4 10             	add    $0x10,%esp
}
8010739f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801073a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073a5:	5b                   	pop    %ebx
801073a6:	5e                   	pop    %esi
801073a7:	5f                   	pop    %edi
801073a8:	5d                   	pop    %ebp
801073a9:	c3                   	ret    
801073aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073b0 <deallocuvm>:
{
801073b0:	f3 0f 1e fb          	endbr32 
801073b4:	55                   	push   %ebp
801073b5:	89 e5                	mov    %esp,%ebp
801073b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801073ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
801073bd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801073c0:	39 d1                	cmp    %edx,%ecx
801073c2:	73 0c                	jae    801073d0 <deallocuvm+0x20>
}
801073c4:	5d                   	pop    %ebp
801073c5:	e9 f6 fa ff ff       	jmp    80106ec0 <deallocuvm.part.0>
801073ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073d0:	89 d0                	mov    %edx,%eax
801073d2:	5d                   	pop    %ebp
801073d3:	c3                   	ret    
801073d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073df:	90                   	nop

801073e0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801073e0:	f3 0f 1e fb          	endbr32 
801073e4:	55                   	push   %ebp
801073e5:	89 e5                	mov    %esp,%ebp
801073e7:	57                   	push   %edi
801073e8:	56                   	push   %esi
801073e9:	53                   	push   %ebx
801073ea:	83 ec 0c             	sub    $0xc,%esp
801073ed:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801073f0:	85 f6                	test   %esi,%esi
801073f2:	74 55                	je     80107449 <freevm+0x69>
  if(newsz >= oldsz)
801073f4:	31 c9                	xor    %ecx,%ecx
801073f6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801073fb:	89 f0                	mov    %esi,%eax
801073fd:	89 f3                	mov    %esi,%ebx
801073ff:	e8 bc fa ff ff       	call   80106ec0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107404:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010740a:	eb 0b                	jmp    80107417 <freevm+0x37>
8010740c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107410:	83 c3 04             	add    $0x4,%ebx
80107413:	39 df                	cmp    %ebx,%edi
80107415:	74 23                	je     8010743a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107417:	8b 03                	mov    (%ebx),%eax
80107419:	a8 01                	test   $0x1,%al
8010741b:	74 f3                	je     80107410 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010741d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107422:	83 ec 0c             	sub    $0xc,%esp
80107425:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107428:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010742d:	50                   	push   %eax
8010742e:	e8 5d b0 ff ff       	call   80102490 <kfree>
80107433:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107436:	39 df                	cmp    %ebx,%edi
80107438:	75 dd                	jne    80107417 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010743a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010743d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107440:	5b                   	pop    %ebx
80107441:	5e                   	pop    %esi
80107442:	5f                   	pop    %edi
80107443:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107444:	e9 47 b0 ff ff       	jmp    80102490 <kfree>
    panic("freevm: no pgdir");
80107449:	83 ec 0c             	sub    $0xc,%esp
8010744c:	68 89 80 10 80       	push   $0x80108089
80107451:	e8 3a 8f ff ff       	call   80100390 <panic>
80107456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010745d:	8d 76 00             	lea    0x0(%esi),%esi

80107460 <setupkvm>:
{
80107460:	f3 0f 1e fb          	endbr32 
80107464:	55                   	push   %ebp
80107465:	89 e5                	mov    %esp,%ebp
80107467:	56                   	push   %esi
80107468:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107469:	e8 e2 b1 ff ff       	call   80102650 <kalloc>
8010746e:	89 c6                	mov    %eax,%esi
80107470:	85 c0                	test   %eax,%eax
80107472:	74 42                	je     801074b6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107474:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107477:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010747c:	68 00 10 00 00       	push   $0x1000
80107481:	6a 00                	push   $0x0
80107483:	50                   	push   %eax
80107484:	e8 67 d7 ff ff       	call   80104bf0 <memset>
80107489:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010748c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010748f:	83 ec 08             	sub    $0x8,%esp
80107492:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107495:	ff 73 0c             	pushl  0xc(%ebx)
80107498:	8b 13                	mov    (%ebx),%edx
8010749a:	50                   	push   %eax
8010749b:	29 c1                	sub    %eax,%ecx
8010749d:	89 f0                	mov    %esi,%eax
8010749f:	e8 8c f9 ff ff       	call   80106e30 <mappages>
801074a4:	83 c4 10             	add    $0x10,%esp
801074a7:	85 c0                	test   %eax,%eax
801074a9:	78 15                	js     801074c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801074ab:	83 c3 10             	add    $0x10,%ebx
801074ae:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801074b4:	75 d6                	jne    8010748c <setupkvm+0x2c>
}
801074b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074b9:	89 f0                	mov    %esi,%eax
801074bb:	5b                   	pop    %ebx
801074bc:	5e                   	pop    %esi
801074bd:	5d                   	pop    %ebp
801074be:	c3                   	ret    
801074bf:	90                   	nop
      freevm(pgdir);
801074c0:	83 ec 0c             	sub    $0xc,%esp
801074c3:	56                   	push   %esi
      return 0;
801074c4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801074c6:	e8 15 ff ff ff       	call   801073e0 <freevm>
      return 0;
801074cb:	83 c4 10             	add    $0x10,%esp
}
801074ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801074d1:	89 f0                	mov    %esi,%eax
801074d3:	5b                   	pop    %ebx
801074d4:	5e                   	pop    %esi
801074d5:	5d                   	pop    %ebp
801074d6:	c3                   	ret    
801074d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074de:	66 90                	xchg   %ax,%ax

801074e0 <kvmalloc>:
{
801074e0:	f3 0f 1e fb          	endbr32 
801074e4:	55                   	push   %ebp
801074e5:	89 e5                	mov    %esp,%ebp
801074e7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801074ea:	e8 71 ff ff ff       	call   80107460 <setupkvm>
801074ef:	a3 04 68 11 80       	mov    %eax,0x80116804
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074f4:	05 00 00 00 80       	add    $0x80000000,%eax
801074f9:	0f 22 d8             	mov    %eax,%cr3
}
801074fc:	c9                   	leave  
801074fd:	c3                   	ret    
801074fe:	66 90                	xchg   %ax,%ax

80107500 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107500:	f3 0f 1e fb          	endbr32 
80107504:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107505:	31 c9                	xor    %ecx,%ecx
{
80107507:	89 e5                	mov    %esp,%ebp
80107509:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010750c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010750f:	8b 45 08             	mov    0x8(%ebp),%eax
80107512:	e8 99 f8 ff ff       	call   80106db0 <walkpgdir>
  if(pte == 0)
80107517:	85 c0                	test   %eax,%eax
80107519:	74 05                	je     80107520 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010751b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010751e:	c9                   	leave  
8010751f:	c3                   	ret    
    panic("clearpteu");
80107520:	83 ec 0c             	sub    $0xc,%esp
80107523:	68 9a 80 10 80       	push   $0x8010809a
80107528:	e8 63 8e ff ff       	call   80100390 <panic>
8010752d:	8d 76 00             	lea    0x0(%esi),%esi

80107530 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107530:	f3 0f 1e fb          	endbr32 
80107534:	55                   	push   %ebp
80107535:	89 e5                	mov    %esp,%ebp
80107537:	57                   	push   %edi
80107538:	56                   	push   %esi
80107539:	53                   	push   %ebx
8010753a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010753d:	e8 1e ff ff ff       	call   80107460 <setupkvm>
80107542:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107545:	85 c0                	test   %eax,%eax
80107547:	0f 84 9b 00 00 00    	je     801075e8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010754d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107550:	85 c9                	test   %ecx,%ecx
80107552:	0f 84 90 00 00 00    	je     801075e8 <copyuvm+0xb8>
80107558:	31 f6                	xor    %esi,%esi
8010755a:	eb 46                	jmp    801075a2 <copyuvm+0x72>
8010755c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107560:	83 ec 04             	sub    $0x4,%esp
80107563:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107569:	68 00 10 00 00       	push   $0x1000
8010756e:	57                   	push   %edi
8010756f:	50                   	push   %eax
80107570:	e8 1b d7 ff ff       	call   80104c90 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107575:	58                   	pop    %eax
80107576:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010757c:	5a                   	pop    %edx
8010757d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107580:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107585:	89 f2                	mov    %esi,%edx
80107587:	50                   	push   %eax
80107588:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010758b:	e8 a0 f8 ff ff       	call   80106e30 <mappages>
80107590:	83 c4 10             	add    $0x10,%esp
80107593:	85 c0                	test   %eax,%eax
80107595:	78 61                	js     801075f8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107597:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010759d:	39 75 0c             	cmp    %esi,0xc(%ebp)
801075a0:	76 46                	jbe    801075e8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801075a2:	8b 45 08             	mov    0x8(%ebp),%eax
801075a5:	31 c9                	xor    %ecx,%ecx
801075a7:	89 f2                	mov    %esi,%edx
801075a9:	e8 02 f8 ff ff       	call   80106db0 <walkpgdir>
801075ae:	85 c0                	test   %eax,%eax
801075b0:	74 61                	je     80107613 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
801075b2:	8b 00                	mov    (%eax),%eax
801075b4:	a8 01                	test   $0x1,%al
801075b6:	74 4e                	je     80107606 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
801075b8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801075ba:	25 ff 0f 00 00       	and    $0xfff,%eax
801075bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801075c2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801075c8:	e8 83 b0 ff ff       	call   80102650 <kalloc>
801075cd:	89 c3                	mov    %eax,%ebx
801075cf:	85 c0                	test   %eax,%eax
801075d1:	75 8d                	jne    80107560 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801075d3:	83 ec 0c             	sub    $0xc,%esp
801075d6:	ff 75 e0             	pushl  -0x20(%ebp)
801075d9:	e8 02 fe ff ff       	call   801073e0 <freevm>
  return 0;
801075de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801075e5:	83 c4 10             	add    $0x10,%esp
}
801075e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ee:	5b                   	pop    %ebx
801075ef:	5e                   	pop    %esi
801075f0:	5f                   	pop    %edi
801075f1:	5d                   	pop    %ebp
801075f2:	c3                   	ret    
801075f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075f7:	90                   	nop
      kfree(mem);
801075f8:	83 ec 0c             	sub    $0xc,%esp
801075fb:	53                   	push   %ebx
801075fc:	e8 8f ae ff ff       	call   80102490 <kfree>
      goto bad;
80107601:	83 c4 10             	add    $0x10,%esp
80107604:	eb cd                	jmp    801075d3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107606:	83 ec 0c             	sub    $0xc,%esp
80107609:	68 be 80 10 80       	push   $0x801080be
8010760e:	e8 7d 8d ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107613:	83 ec 0c             	sub    $0xc,%esp
80107616:	68 a4 80 10 80       	push   $0x801080a4
8010761b:	e8 70 8d ff ff       	call   80100390 <panic>

80107620 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107620:	f3 0f 1e fb          	endbr32 
80107624:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107625:	31 c9                	xor    %ecx,%ecx
{
80107627:	89 e5                	mov    %esp,%ebp
80107629:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010762c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010762f:	8b 45 08             	mov    0x8(%ebp),%eax
80107632:	e8 79 f7 ff ff       	call   80106db0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107637:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107639:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010763a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010763c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107641:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107644:	05 00 00 00 80       	add    $0x80000000,%eax
80107649:	83 fa 05             	cmp    $0x5,%edx
8010764c:	ba 00 00 00 00       	mov    $0x0,%edx
80107651:	0f 45 c2             	cmovne %edx,%eax
}
80107654:	c3                   	ret    
80107655:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010765c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107660 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107660:	f3 0f 1e fb          	endbr32 
80107664:	55                   	push   %ebp
80107665:	89 e5                	mov    %esp,%ebp
80107667:	57                   	push   %edi
80107668:	56                   	push   %esi
80107669:	53                   	push   %ebx
8010766a:	83 ec 0c             	sub    $0xc,%esp
8010766d:	8b 75 14             	mov    0x14(%ebp),%esi
80107670:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107673:	85 f6                	test   %esi,%esi
80107675:	75 3c                	jne    801076b3 <copyout+0x53>
80107677:	eb 67                	jmp    801076e0 <copyout+0x80>
80107679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107680:	8b 55 0c             	mov    0xc(%ebp),%edx
80107683:	89 fb                	mov    %edi,%ebx
80107685:	29 d3                	sub    %edx,%ebx
80107687:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010768d:	39 f3                	cmp    %esi,%ebx
8010768f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107692:	29 fa                	sub    %edi,%edx
80107694:	83 ec 04             	sub    $0x4,%esp
80107697:	01 c2                	add    %eax,%edx
80107699:	53                   	push   %ebx
8010769a:	ff 75 10             	pushl  0x10(%ebp)
8010769d:	52                   	push   %edx
8010769e:	e8 ed d5 ff ff       	call   80104c90 <memmove>
    len -= n;
    buf += n;
801076a3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801076a6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
801076ac:	83 c4 10             	add    $0x10,%esp
801076af:	29 de                	sub    %ebx,%esi
801076b1:	74 2d                	je     801076e0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
801076b3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801076b5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801076b8:	89 55 0c             	mov    %edx,0xc(%ebp)
801076bb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801076c1:	57                   	push   %edi
801076c2:	ff 75 08             	pushl  0x8(%ebp)
801076c5:	e8 56 ff ff ff       	call   80107620 <uva2ka>
    if(pa0 == 0)
801076ca:	83 c4 10             	add    $0x10,%esp
801076cd:	85 c0                	test   %eax,%eax
801076cf:	75 af                	jne    80107680 <copyout+0x20>
  }
  return 0;
}
801076d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076d9:	5b                   	pop    %ebx
801076da:	5e                   	pop    %esi
801076db:	5f                   	pop    %edi
801076dc:	5d                   	pop    %ebp
801076dd:	c3                   	ret    
801076de:	66 90                	xchg   %ax,%ax
801076e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076e3:	31 c0                	xor    %eax,%eax
}
801076e5:	5b                   	pop    %ebx
801076e6:	5e                   	pop    %esi
801076e7:	5f                   	pop    %edi
801076e8:	5d                   	pop    %ebp
801076e9:	c3                   	ret    
