commit 5c9c96376e18f09fadc187b8d5ae0feb699bbf14
Author: froggy666uk <froggy666uk@gmail.com>
Date:   Thu Jul 25 11:05:42 2013 +0100

    Enable westwood TCP congestion alg and make default

commit b06a7e09f5270259cac45ccc4ec434e720478c03
Author: froggy666uk <froggy666uk@gmail.com>
Date:   Thu Jul 25 11:01:58 2013 +0100

    defconfig: enable dynamic fsync and make row default scheduler

commit 4e3de6cddf2fd80371075eb0395f742a3f94009e
Author: froggy666uk <froggy666uk@gmail.com>
Date:   Thu Jul 25 10:50:22 2013 +0100

    defconfig: Create froggy_grouper_defconfig

commit 45971f9b2153dd0273f524d5c50b84ff72f9c5d7
Author: Paul Reioux <reioux@gmail.com>
Date:   Mon Jun 10 02:19:36 2013 -0500

    dynamic fsync: don't disable fdatasync()
    
    Signed-off-by: Paul Reioux <reioux@gmail.com>

commit 60d44b9f4293073e2a7a9cf3d215b1ae3dbf89ca
Author: Lee Susman <lsusman@codeaurora.org>
Date:   Sun May 5 14:31:17 2013 +0000

    mm: pass readahead info down to the i/o scheduler
    
    Some i/o schedulers (i.e. row-iosched, cfq-iosched) deploy an idling
    algorithm in order to be better synced with the readahead algorithm.
    Idling is a prediction algorithm for incoming read requests.
    
    In this patch we mark pages which are part of a readahead window, by
    setting a newly introduced flag. With this flag, the i/o scheduler can
    identify a request which is associated with a readahead page. This
    enables the i/o scheduler's idling mechanism to be en-sync with the
    readahead mechanism and, in turn, can increase read throughput.
    
    Change-Id: I0654f23315b6d19d71bcc9cc029c6b281a44b196
    Signed-off-by: Lee Susman <lsusman@codeaurora.org>

commit ffe89115979dc0e6abf9b72e5d003643df254f20
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Sat Jan 12 16:23:18 2013 +0200

    block: row: Aggregate row_queue parameters to one structure
    
    Each ROW queues has several parameters which default values are defined
    in separate arrays. This patch aggregates all default values into one
    array.
    The values in question are:
     - is idling enabled for the queue
     - queue quantum
     - can the queue notify on urgent request
    
    Change-Id: I3821b0a042542295069b340406a16b1000873ec6
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit b56001559365c7aa7b5fe9f18f7652c8615fd56b
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Sat Jan 12 16:21:47 2013 +0200

    block: row: fix sysfs functions - idle_time conversion
    
    idle_time was updated to be stored in msec instead of jiffies.
    So there is no need to convert the value when reading from user or
    displaying the value to him.
    
    Change-Id: I58e074b204e90a90536d32199ac668112966e9cf
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit 728867b20b875a0e944eed9756a41b63e5bd7998
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Sat Jan 12 16:21:12 2013 +0200

    block: row: Insert dispatch_quantum into struct row_queue
    
    There is really no point in keeping the dispatch quantum
    of a queue outside of it. By inserting it to the row_queue
    structure we spare extra level in accessing it.
    
    Change-Id: Ic77571818b643e71f9aafbb2ca93d0a92158b199
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit f54a6c949b13e615a29eabf834aa09c27a2b4c71
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Sun Jan 13 22:04:59 2013 +0200

    block: row: Add some debug information on ROW queues
    
    1. Add a counter for number of requests on queue.
    2. Add function to print queues status (number requests
       currently on queue and number of already dispatched requests
       in current dispatch cycle).
    
    Change-Id: I1e98b9ca33853e6e6a8ddc53240f6cd6981e6024
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit d8820d2a82b5bbf196a629e46f374f75b14bf1c2
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Thu Dec 20 19:23:58 2012 +0200

    row: Add support for urgent request handling
    
    This patch adds support for handling urgent requests.
    ROW queue can be marked as "urgent" so if it was un-served in last
    dispatch cycle and a request was added to it - it will trigger
    issuing an urgent-request-notification to the block device driver.
    The block device driver may choose at stop the transmission of current
    ongoing request to handle the urgent one. Foe example: long WRITE may
    be stopped to handle an urgent READ. This decreases READ latency.
    
    Change-Id: I84954c13f5e3b1b5caeadc9fe1f9aa21208cb35e
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit fbb610b4d2ca9d7b461cb93f9cee14186955ec28
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Thu Dec 6 13:17:19 2012 +0200

    block:row: fix idling mechanism in ROW
    
    This patch addresses the following issues found in the ROW idling
    mechanism:
    1. Fix the delay passed to queue_delayed_work (pass actual delay
       and not the time when to start the work)
    2. Change the idle time and the idling-trigger frequency to be
       HZ dependent (instead of using msec_to_jiffies())
    3. Destroy idle_workqueue() in queue_exit
    
    Change-Id: If86513ad6b4be44fb7a860f29bd2127197d8d5bf
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit f9aa54730fbc733ae055c1a8ba8399986a7bcdf0
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Tue Oct 30 08:33:06 2012 +0200

    row: Adding support for reinsert already dispatched req
    
    Add support for reinserting already dispatched request back to the
    schedulers internal data structures.
    The request will be reinserted back to the queue (head) it was
    dispatched from as if it was never dispatched.
    
    Change-Id: I70954df300774409c25b5821465fb3aa33d8feb5
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit c218c26643944cd867df70953804a47edc62cac3
Author: Paul Reioux <reioux@gmail.com>
Date:   Thu Jun 6 01:24:16 2013 -0500

    block/blk-core: add support for Linux 3.0.x for urgent request handling
    
    Signed-off-by: Paul Reioux <reioux@gmail.com>

commit 695af99d4b9f4988b2439d4e6a8267a82f988147
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Tue Dec 4 16:04:15 2012 +0200

    block: Add API for urgent request handling
    
    This patch add support in block & elevator layers for handling
    urgent requests. The decision if a request is urgent or not is taken
    by the scheduler. Urgent request notification is passed to the underlying
    block device driver (eMMC for example). Block device driver may decide to
    interrupt the currently running low priority request to serve the new
    urgent request. By doing so READ latency is greatly reduced in read&write
    collision scenarios.
    
    Note that if the current scheduler doesn't implement the urgent request
    mechanism, this code path is never activated.
    
    Change-Id: I8aa74b9b45c0d3a2221bd4e82ea76eb4103e7cfa
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit 6aa2c383b8d3b9869cae926648a733e37592cc88
Author: Paul Reioux <reioux@gmail.com>
Date:   Thu Jun 6 01:22:00 2013 -0500

    block: add support for Linux 3.0.x for reinsert a dispatched req
    
    Signed-off-by: Paul Reioux <reioux@gmail.com>

commit 823575907cc5ec44ed89da7b4047068d835fd575
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Tue Dec 4 15:54:43 2012 +0200

    block: Add support for reinsert a dispatched req
    
    Add support for reinserting a dispatched request back to the
    scheduler's internal data structures.
    This capability is used by the device driver when it chooses to
    interrupt the current request transmission and execute another (more
    urgent) pending request. For example: interrupting long write in order
    to handle pending read. The device driver re-inserts the
    remaining write request back to the scheduler, to be rescheduled
    for transmission later on.
    
    Add API for verifying whether the current scheduler
    supports reinserting requests mechanism. If reinsert mechanism isn't
    supported by the scheduler, this code path will never be activated.
    
    Change-Id: I5c982a66b651ebf544aae60063ac8a340d79e67f
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit 72e47ad27b9713916cf5b86c90f4ee631650f20d
Author: Paul Reioux <reioux@gmail.com>
Date:   Thu Jun 6 01:14:00 2013 -0500

    block/row-iosched.c: add support for Linux 3.0.x
    
    Signed-off-by: Paul Reioux <reioux@gmail.com>

commit b0a755e6e05c72157df6ff00f14cf13796c5fc47
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Mon Oct 15 20:56:02 2012 +0200

    block: ROW: Fix forced dispatch
    
    This patch fixes forced dispatch in the ROW scheduling algorithm.
    When the dispatch function is called with the forced flag on, we
    can't delay the dispatch of the requests that are in scheduler queues.
    Thus, when dispatch is called with forced turned on, we need to cancel
    idling, or not to idle at all.
    
    Change-Id: I3aa0da33ad7b59c0731c696f1392b48525b52ddc
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit a85a36a245401ad38fe2e2a91c7967fd14a8d207
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Mon Oct 15 20:50:54 2012 +0200

    block: ROW: Correct minimum values of ROW tunable parameters
    
    The ROW scheduling algorithm exposes several tunable parameters.
    This patch updates the minimum allowed values for those parameters.
    
    Change-Id: I5ec19d54b694e2e83ad5376bd99cc91f084967f5
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

commit ffe712ec4ab8e5ed98734c4dadc066eaea8cc6c7
Author: Tatyana Brokhman <tlinder@codeaurora.org>
Date:   Thu Jun 6 12:40:43 2013 -0500

    block: Adding ROW scheduling algorithm
    
    This patch adds the implementation of a new scheduling algorithm - ROW.
    The policy of this algorithm is to prioritize READ requests over WRITE
    as much as possible without starving the WRITE requests.
    
    Change-Id: I4ed52ea21d43b0e7c0769b2599779a3d3869c519
    Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
    
    Signed-off-by: Paul Reioux <reioux@gmail.com>

commit a7525f66fc13227b747c4bc714f3b44c698e5db7
Author: Paul Reioux <reioux@gmail.com>
Date:   Wed May 22 18:02:19 2013 -0500

    dynamic fsync: add kernel panic notifier to force flush outstanding data
    
    more paranoia safety checks
    
    Signed-off-by: Paul Reioux <reioux@gmail.com>

commit 85ac0302dae3bb6d9e5c5759e0f2dff14915c585
Author: Paul Reioux <reioux@gmail.com>
Date:   Tue May 21 19:21:04 2013 -0500

    dynamic fsync: add reboot notifier to force flush outstanding data
    
    this should further prevent data corruption from kernel panics and
    forced reboots
    
    bump version to 1.2
    
    Signed-off-by: Paul Reioux <reioux@gmail.com>

commit 5fe6957d1bf5692b1eb7ff6abc98c97ef6526f1e
Author: Paul Reioux <reioux@gmail.com>
Date:   Mon Apr 15 14:30:06 2013 -0500

    dynamic fsync: favor true case since most will be using this feature
    
    Signed-off-by: Paul Reioux <reioux@gmail.com>

commit aa89eac18aa3dd83093cf58da7e967d4c8c8d0f2
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Thu Apr 4 13:45:38 2013 -0500

    block: avoid using uninitialized value in from queue_var_store
    
    Date	Wed, 3 Apr 2013 15:30:52 +0000
    
    As found by gcc-4.8, the QUEUE_SYSFS_BIT_FNS macro creates functions
    that use a value generated by queue_var_store independent of whether
    that value was set or not.
    
    block/blk-sysfs.c: In function 'queue_store_nonrot':
    block/blk-sysfs.c:244:385: warning: 'val' may be used uninitialized in this function [-Wmaybe-uninitialized]
    
    Unlike most other such warnings, this one is not a false positive,
    writing any non-number string into the sysfs files indeed has
    an undefined result, rather than returning an error.
    
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Jens Axboe <jaxboe@fusionio.com>

commit d004dfcde0ee84061a397a49f05b4fcd8b370f04
Author: Paul Reioux <reioux@gmail.com>
Date:   Sun Apr 14 00:50:10 2013 -0500

    dynamic filesync: add some cache optimizations
    
    and clean up file format and typos
    
    bump version to 1.1
    
    Signed-off-by: Paul Reioux <reioux@gmail.com>

commit 24e3b944cff1ae84a2f81819636f0004a29bad5c
Author: Andrew Bartholomew <andrewb03@gmail.com>
Date:   Sun Apr 14 00:16:08 2013 -0500

    fs/dyn_fsync: check dyn fsync control's active prior to performing fsync ops
    
    Signed-off-by: Andrew Bartholomew <andrewb03@gmail.com>

commit dda70406d17c6bfffc15430bd8bf841264cfb84b
Author: faux123 <reioux@gmail.com>
Date:   Mon Apr 1 20:00:48 2013 -0500

    sched: remove one division operation in find_buiest_queue()
    
    Thu, 28 Mar 2013 16:58:52 +0900
    
    Remove one division operation in find_buiest_queue().
    
    Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
    backported for Linux 3.1
    
    Signed-off-by: faux123 <reioux@gmail.com>

commit 6acd2223d840a617c8aecd04950a491684459cc3
Author: faux123 <reioux@gmail.com>
Date:   Tue Sep 18 23:23:13 2012 -0700

    fs/dyn_sync_cntrl: dynamic sync control
    
    The dynamic sync control interface uses Android kernel's unique early
    suspend / lat resume interface.
    
    While screen is on, file sync is disabled
    when screen is off, a file sync is called to flush all outstanding writes
    and restore file sync operation as normal.
    
    Signed-off-by: Paul Reioux <reioux@gmail.com>

commit 1e8b3d8ac4fa2c26e979bd00df3ea658ff239995
Author: Todd Poynor <toddpoynor@google.com>
Date:   Tue Jun 4 17:29:38 2013 -0700

    ashmem: avoid deadlock between read and mmap calls
    
    Avoid holding ashmem_mutex across code that can page fault.  Page faults
    grab the mmap_sem for the process, which are also held by mmap calls
    prior to calling ashmem_mmap, which locks ashmem_mutex.  The reversed
    order of locking between the two can deadlock.
    
    The calls that can page fault are read() and the ASHMEM_SET_NAME and
    ASHMEM_GET_NAME ioctls.  Move the code that accesses userspace pages
    outside the ashmem_mutex.
    
    Bug: 9261835
    Change-Id: If1322e981d29c889a56cdc9dfcbc6df2729a45e9
    Signed-off-by: Todd Poynor <toddpoynor@google.com>

commit 5244905a7e5fd589b4397289b692e4251371a179
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Wed Jun 5 17:21:23 2013 -0700

    Revert "Revert "net: wireless: bcmdhd: Enable SUPPORT_PM2_ONLY mode""
    
    This reverts commit 485ba23485cab0b29703f4c098d35cbee66f3a28.

commit 6d70ac4b2bec10bf37b210e6b0bf8bed76a8c608
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Oct 18 09:14:12 2012 +0000

    tcp: fix FIONREAD/SIOCINQ
    
    [ Upstream commit a3374c42aa5f7237e87ff3b0622018636b0c847e ]
    
    tcp_ioctl() tries to take into account if tcp socket received a FIN
    to report correct number bytes in receive queue.
    
    But its flaky because if the application ate the last skb,
    we return 1 instead of 0.
    
    Correct way to detect that FIN was received is to test SOCK_DONE.
    
    Reported-by: Elliot Hughes <enh@google.com>
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Cc: Neal Cardwell <ncardwell@google.com>
    Cc: Tom Herbert <therbert@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Ed Tam <etam@google.com>

commit 485ba23485cab0b29703f4c098d35cbee66f3a28
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Fri May 31 10:50:52 2013 -0700

    Revert "net: wireless: bcmdhd: Enable SUPPORT_PM2_ONLY mode"
    
    This reverts commit c8e978bfb0b1ae26b9376b8d66e39292d153d50b.

commit d91c56b88a6608ede830ac68c340a40bfad213b9
Author: Tommi Rantala <tt.rantala@gmail.com>
Date:   Sat Apr 13 22:49:14 2013 +0300

    perf: Treat attr.config as u64 in perf_swevent_init()
    
    Trinity discovered that we fail to check all 64 bits of
    attr.config passed by user space, resulting to out-of-bounds
    access of the perf_swevent_enabled array in
    sw_perf_event_destroy().
    
    Introduced in commit b0a873ebb ("perf: Register PMU
    implementations").
    
    Signed-off-by: Tommi Rantala <tt.rantala@gmail.com>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: davej@redhat.com
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
    Link: http://lkml.kernel.org/r/1365882554-30259-1-git-send-email-tt.rantala@gmail.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

commit 69d39c17ad980b126c982bf691a582b2c5101d76
Author: Haley Teng <hteng@nvidia.com>
Date:   Sat May 4 02:00:37 2013 +0800

    asoc: tegra: need to enable ahub clocks before accessing DAM registers
    
    To avoid hard hang when you execute the below command lines
    
    - cat /sys/kernel/debug/asoc/tegra30-dam.0
    - cat /sys/kernel/debug/asoc/tegra30-dam.1
    - cat /sys/kernel/debug/asoc/tegra30-dam.2
    
    Bug 1283024
    
    Change-Id: I1c18bd5c1bbf6059930b8bbb279e4a8596c85bdd
    Signed-off-by: Haley Teng <hteng@nvidia.com>

commit fbdf8f1fe8400f366395ce142ec29c767bff0bfd
Author: Jon Mayo <jmayo@nvidia.com>
Date:   Sat May 4 01:54:35 2013 +0800

    video: tegra: avoid null deref on nvdps read
    
    When reading nvdps sysfs file, check mode to avoid a null dereference.
    
    Bug 1032235
    Bug 1283024
    
    Change-Id: I19b3b5b3de6743cdcc9e3a846a4ba102de681ad3
    Signed-off-by: Haley Teng <hteng@nvidia.com>

commit afe7804f3e6d349b91789c641c47f4fb00bd2917
Author: Ken Sumrall <ksumrall@android.com>
Date:   Tue Apr 9 14:41:18 2013 -0700

    Revert "mmc: card: Bypass discard for Hynix and Kingston"
    
    Moving away from the ext4 "discard" mount option to using fstrim,
    any perceived performance loss due to enabling discard on Hynix or
    Kingston emmc chips is less important, and those chips do benefit
    from the discard command.  So I'm reverting this patch so fstrim
    will work on non-Samsung emmc devices.
    
    Bug: 8056794
    
    This reverts commit 5c6426d0ea1ae8b9c617afe2dd8176ec1818653f.
    
    Change-Id: Ifc61a553c0430928fc78b14f64e25c925bea224b

commit 7b061ad96e3c1f17e6e7d57e85a8188dbfb49f61
Author: Joseph_Wu <joseph_wu@asus.com>
Date:   Mon Apr 29 20:31:58 2013 -0700

    Sensors: Fix a drift when running at lower rate.
    
    Change-Id: I308940ae68dc4d6ce1fa4e4879bc17aefd5121b5
    Signed-off-by: Joseph_Wu <joseph_wu@asus.com>

commit 1a9a0972a0aeaeb9d822dd8bc7c098806533ea02
Author: Haley Teng <hteng@nvidia.com>
Date:   Thu Apr 11 21:00:58 2013 +0800

    arm: tegra: apbio: move init call to subsys_initcall
    
    Signed-off-by: Haley Teng <hteng@nvidia.com>

commit 07042725084e8d2e9ec50961b798e70b32699b48
Author: Kees Cook <keescook@chromium.org>
Date:   Wed Mar 13 14:59:33 2013 -0700

    signal: always clear sa_restorer on execve
    
    When the new signal handlers are set up, the location of sa_restorer is
    not cleared, leaking a parent process's address space location to
    children.  This allows for a potential bypass of the parent's ASLR by
    examining the sa_restorer value returned when calling sigaction().
    
    Based on what should be considered "secret" about addresses, it only
    matters across the exec not the fork (since the VMAs haven't changed
    until the exec).  But since exec sets SIG_DFL and keeps sa_restorer,
    this is where it should be fixed.
    
    Given the few uses of sa_restorer, a "set" function was not written
    since this would be the only use.  Instead, we use
    __ARCH_HAS_SA_RESTORER, as already done in other places.
    
    Example of the leak before applying this patch:
    
      $ cat /proc/$$/maps
      ...
      7fb9f3083000-7fb9f3238000 r-xp 00000000 fd:01 404469 .../libc-2.15.so
      ...
      $ ./leak
      ...
      7f278bc74000-7f278be29000 r-xp 00000000 fd:01 404469 .../libc-2.15.so
      ...
      1 0 (nil) 0x7fb9f30b94a0
      2 4000000 (nil) 0x7f278bcaa4a0
      3 4000000 (nil) 0x7f278bcaa4a0
      4 0 (nil) 0x7fb9f30b94a0
      ...
    
    [akpm@linux-foundation.org: use SA_RESTORER for backportability]
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Reported-by: Emese Revfy <re.emese@gmail.com>
    Cc: Emese Revfy <re.emese@gmail.com>
    Cc: PaX Team <pageexec@freemail.hu>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Oleg Nesterov <oleg@redhat.com>
    Cc: "Eric W. Biederman" <ebiederm@xmission.com>
    Cc: Serge Hallyn <serge.hallyn@canonical.com>
    Cc: Julien Tinnes <jln@google.com>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    
    Signed-off-by: Ed Tam <etam@google.com>

commit 16b49352e4922a9e9fb1b735be6f7c1525f5f6ab
Author: Ed Tam <etam@google.com>
Date:   Fri Apr 5 23:50:33 2013 +0000

    Revert "Revert "Sensors: Some updates for Invensense v5.1.5 IIO driver release.""
    
    Sensors added back with fix.
    
    This reverts commit d90e3d9e757b6d776a535b8f6fb85ed78f5b6fd8
    
    Change-Id: Ic732f3603f6d8aac8591d960f915ef6f06ab152a

commit d90e3d9e757b6d776a535b8f6fb85ed78f5b6fd8
Author: Ed Tam <etam@google.com>
Date:   Thu Apr 4 00:54:19 2013 +0000

    Revert "Sensors: Some updates for Invensense v5.1.5 IIO driver release."
    
    This reverts commit 28ec66dec02955f0c62bcf6829c61b96ed9821c4
    
    Change-Id: If4be3c26ef1ca7f057ad1bda2755da4878b4dcd4

commit 53b2c1318265d2eb5e01e9604b72906c90ece165
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Tue Feb 19 14:56:53 2013 +0100

    wake_up_process() should be never used to wakeup a TASK_STOPPED/TRACED task
    
    wake_up_process() should never wakeup a TASK_STOPPED/TRACED task.
    Change it to use TASK_NORMAL and add the WARN_ON().
    
    TASK_ALL has no other users, probably can be killed.
    
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Michal Hocko <mhocko@suse.cz>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Ed Tam <etam@google.com>

commit 98c318c71115457d1028c3ecbfbbec981098234e
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Tue Feb 19 14:56:52 2013 +0100

    ptrace: ensure arch_ptrace/ptrace_request can never race with SIGKILL
    
    putreg() assumes that the tracee is not running and pt_regs_access() can
    safely play with its stack.  However a killed tracee can return from
    ptrace_stop() to the low-level asm code and do RESTORE_REST, this means
    that debugger can actually read/modify the kernel stack until the tracee
    does SAVE_REST again.
    
    set_task_blockstep() can race with SIGKILL too and in some sense this
    race is even worse, the very fact the tracee can be woken up breaks the
    logic.
    
    As Linus suggested we can clear TASK_WAKEKILL around the arch_ptrace()
    call, this ensures that nobody can ever wakeup the tracee while the
    debugger looks at it.  Not only this fixes the mentioned problems, we
    can do some cleanups/simplifications in arch_ptrace() paths.
    
    Probably ptrace_unfreeze_traced() needs more callers, for example it
    makes sense to make the tracee killable for oom-killer before
    access_process_vm().
    
    While at it, add the comment into may_ptrace_stop() to explain why
    ptrace_stop() still can't rely on SIGKILL and signal_pending_state().
    
    Reported-by: Salman Qazi <sqazi@google.com>
    Reported-by: Suleiman Souhlal <suleiman@google.com>
    Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Michal Hocko <mhocko@suse.cz>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Ed Tam <etam@google.com>
    
    Conflicts:
    	kernel/ptrace.c

commit 895afd754135c22647238476cfd33c317835f730
Author: Oleg Nesterov <oleg@redhat.com>
Date:   Tue Feb 19 14:56:51 2013 +0100

    ptrace: introduce signal_wake_up_state() and ptrace_signal_wake_up()
    
    Cleanup and preparation for the next change.
    
    signal_wake_up(resume => true) is overused. None of ptrace/jctl callers
    actually want to wakeup a TASK_WAKEKILL task, but they can't specify the
    necessary mask.
    
    Turn signal_wake_up() into signal_wake_up_state(state), reintroduce
    signal_wake_up() as a trivial helper, and add ptrace_signal_wake_up()
    which adds __TASK_TRACED.
    
    This way ptrace_signal_wake_up() can work "inside" ptrace_request()
    even if the tracee doesn't have the TASK_WAKEKILL bit set.
    
    Signed-off-by: Oleg Nesterov <oleg@redhat.com>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Michal Hocko <mhocko@suse.cz>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Ed Tam <etam@google.com>
    
    Conflicts:
    	kernel/ptrace.c

commit db8427fad496686bdfca47930d173f350669ffba
Author: jim1_lin <jim1_lin@asus.com>
Date:   Mon Apr 1 15:25:22 2013 +0800

    ARM: tegra: grouper: Add region mapping for IR.
    
    There is no region domain mapping for IR in firmware,
    add mapping for IR from driver side.
    
    Change-Id: Iffba01b63f55fcc951ac036ba20679a500663de9
    Signed-off-by: jim1_lin <jim1_lin@asus.com>

commit 28ec66dec02955f0c62bcf6829c61b96ed9821c4
Author: Joseph Wu <Joseph_Wu@asus.com>
Date:   Wed Mar 27 22:23:26 2013 +0800

    Sensors: Some updates for Invensense v5.1.5 IIO driver release.
    
    Change-Id: Idfc8df88847c05ef358026d47bd0c2e8304a5621
    Signed-off-by: Joseph Wu <Joseph_Wu@asus.com>

commit 591ec563cafd9b9b1b69af49f7106242b116efc0
Author: Ed Tam <etam@google.com>
Date:   Fri Mar 29 22:11:13 2013 -0700

    Enable SELinux and its dependencies in the tegra3_android_defconfig
    
    Signed-off-by: Ed Tam <etam@google.com>

commit 8c9090d0c25204f1cd083c88ba0889d0a5abbccc
Author: Stephen Smalley <sds@tycho.nsa.gov>
Date:   Thu Nov 15 14:01:44 2012 -0500

    Fix security_binder_transfer_binder hook.
    
    Drop the owning task argument to security_binder_transfer_binder
    since ref->node->proc can be NULL (dead owner?).
    Revise the SELinux checking to apply a single transfer check between
    the source and destination tasks.  Owning task is no longer relevant.
    Drop the receive permission definition as it is no longer used.
    
    This makes the transfer permission similar to the call permission; it is only
    useful if you want to allow a binder IPC between two tasks (call permission)
    but deny passing of binder references between them (transfer permission).
    
    Signed-off-by: Ed Tam <etam@google.com>

commit 9f2a76d5e56771f76ef1bd9274aa7ac40d7c8a62
Author: Stephen Smalley <sds@tycho.nsa.gov>
Date:   Mon Dec 19 16:44:10 2011 -0500

    Add permission checking for binder IPC.
    
    Signed-off-by: Ed Tam <etam@google.com>

commit 5f7a2090813a215271eda4a1ca7b1d9169fbc1ab
Author: Ed Tam <etam@google.com>
Date:   Fri Mar 29 11:18:56 2013 -0700

    Disable loadable module support
    
    BUG: 8445904
    
    Signed-off-by: Ed Tam <etam@google.com>

commit 48299b59f37284cf26699daca37f9f15410d6c71
Author: Ed Tam <etam@google.com>
Date:   Fri Mar 29 11:17:06 2013 -0700

    Disable access to .config through /proc/config.gz
    
    BUG: 8445234
    
    Signed-off-by: Ed Tam <etam@google.com>

commit 4df728baf2e8b28e8f26f05fc35120cefd735fe3
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Mon Mar 18 10:54:41 2013 -0700

    net: wireless: bcmdhd: Fix p2p "linear" IE parsing
    
    Change-Id: Id9e358897529940eaaa6654f67297e1b77f52d15
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 42201549f81405638132ea2c9fc46b73073bc700
Author: JP Abgrall <jpa@google.com>
Date:   Wed Feb 6 17:40:07 2013 -0800

    netfilter: xt_qtaguid: Allow tracking loopback
    
    In the past it would always ignore interfaces with loopback addresses.
    Now we just treat them like any other.
    This also helps with writing tests that check for the presence
    of the qtaguid module.
    
    Signed-off-by: JP Abgrall <jpa@google.com>

commit a4ebe12db3ecb894851faed22aaa8df747d450d6
Author: JP Abgrall <jpa@google.com>
Date:   Tue Jan 29 19:29:35 2013 -0800

    netfilter: xt_qtaguid: extend iface stat to report protocols
    
    In the past the iface_stat_fmt would only show global bytes/packets
    for the skb-based numbers.
    For stall detection in userspace, distinguishing tcp vs other protocols
    makes it easier.
    Now we report
      ifname total_skb_rx_bytes total_skb_rx_packets total_skb_tx_bytes
      total_skb_tx_packets {rx,tx}_{tcp,udp,ohter}_{bytes,packets}
    
    Bug: 6818637
    Signed-off-by: JP Abgrall <jpa@google.com>
    Change-Id: I179c5ebf2fe822acec0bce4973b4bbb5e7d5076d

commit a915494e82439dea53fc5597f2eb20d979e454aa
Author: JP Abgrall <jpa@google.com>
Date:   Fri Jan 4 18:18:36 2013 -0800

    netfilter: xt_qtaguid: remove AID_* dependency for access control
    
    qtaguid limits what can be done with /ctrl and /stats based on group
    membership.
    This changes removes AID_NET_BW_STATS and AID_NET_BW_ACCT, and picks
    up the groups from the gid of the matching proc entry files.
    
    Signed-off-by: JP Abgrall <jpa@google.com>
    Change-Id: I42e477adde78a12ed5eb58fbc0b277cdaadb6f94

commit 4e21be2039dfcc0a0885391f086da2c09d98ae3c
Author: Pontus Fuchs <pontus.fuchs@gmail.com>
Date:   Mon Nov 19 11:44:51 2012 -0800

    netfilter: qtaguid: Don't BUG_ON if create_if_tag_stat fails
    
    If create_if_tag_stat fails to allocate memory (GFP_ATOMIC) the
    following will happen:
    
    qtaguid: iface_stat: tag stat alloc failed
    ...
    kernel BUG at xt_qtaguid.c:1482!
    
    Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>

commit 5510cf525154c2b15ad7e4f86d46557c8a8b1e44
Author: JP Abgrall <jpa@google.com>
Date:   Tue Oct 9 20:38:21 2012 -0700

    netfilter: xt_qtaguid: fix error exit that would keep a spinlock.
    
    qtudev_open() could return with a uid_tag_data_tree_lock held
    when an kzalloc(..., GFP_ATOMIC) would fail.
    Very unlikely to get triggered AND survive the mayhem of running out of mem.
    
    Signed-off-by: JP Abgrall <jpa@google.com>

commit 6079829406d3f30a3289040212a58a92e46cd6dc
Author: Lorenzo Colitti <lorenzo@google.com>
Date:   Wed Mar 6 13:14:38 2013 -0800

    net: ipv6: Don't purge default router if accept_ra=2
    
    Setting net.ipv6.conf.<interface>.accept_ra=2 causes the kernel
    to accept RAs even when forwarding is enabled. However, enabling
    forwarding purges all default routes on the system, breaking
    connectivity until the next RA is received. Fix this by not
    purging default routes on interfaces that have accept_ra=2.
    
    Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
    Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
    Acked-by: Eric Dumazet <edumazet@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Iliyan Malchev <malchev@google.com>

commit ab743ecc2b1d42663c9226d031944f480f31dc76
Author: Michael Wright <michaelwr@google.com>
Date:   Wed Feb 27 14:53:59 2013 -0800

    ARM: tegra: grouper: Enable HIDDEV
    
    Change-Id: If0f66e41917ab63ab2adf912e91122129fa1ecb3
    Signed-off-by: Michael Wright <michaelwr@google.com>

commit 618d85d001db868455ba50c66a748ae6d4bae45c
Author: Joseph Wu <Joseph_Wu@asus.com>
Date:   Mon Feb 25 19:03:01 2013 +0800

    Sensors: Invensense v5.1.5 IIO driver release.
    
    - New driver with mpl v5.1.5 is released.
    - Provided by Invensense.
    
    Change-Id: I6404c04fd79d1d88413675af6d25d21ddec57fc8
    Signed-off-by: Joseph Wu <Joseph_Wu@asus.com>

commit 79fcccd3d4d51e079511c65d398287477bed9b85
Author: jerryyc_hu <jerryyc_hu@asus.com>
Date:   Tue Jan 22 23:13:18 2013 +0800

    8047490 Change battery-driver for IEEE 1725 certificate.
    
    Stop charging if i2c communication failure, battery over temperature or using non-original battery.
    
    Change-Id: I866c1f1044d21ec177d5daca3f286a32326a08f8

commit 88875f45a2e57a03d47543bb99aaf4401ddc837f
Author: pomelo_hsieh <pomelo_hsieh@asus.com>
Date:   Thu Feb 7 11:20:39 2013 +0800

    To make charger-ic to be able to detect charger type when battery out of power.
    
    Change-Id: I29acee37aed5594e218ba24c8bd4840bd95bf476

commit c6940b574c686ea9a6c1232af38a8f882a2f2901
Author: jim1_lin <jim1_lin@asus.com>
Date:   Wed Dec 26 11:29:53 2012 +0800

    ARM: tegra: grouper: Enable 802.11n for Russia.
    
    Replace RU to XY.
    
    Change-Id: I3ecb1f247f7419e511031e13cb85c23693b668ff

commit c8e978bfb0b1ae26b9376b8d66e39292d153d50b
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Fri Feb 8 13:43:47 2013 -0800

    net: wireless: bcmdhd: Enable SUPPORT_PM2_ONLY mode
    
    Change-Id: I4f8132191454f0a12f7613388229fed9be5216c9
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 02adeb90a4431108b1b11f01dbe4b61d3f6e4c02
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Fri Feb 8 12:08:48 2013 -0800

    net: wireless: bcmdhd: Add SUPPORT_PM2_ONLY option
    
    Change-Id: Ieb2569cb7fb2bbc56ff9abbc8728a7741fda0027
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 611639c906be0b849693ad6aeec98c84fbb7f5fa
Author: Ed Tam <etam@google.com>
Date:   Tue Feb 5 16:06:35 2013 -0800

    tegra3_android_defconfig: Enable CONFIG_EXT4_FS_SECURITY option

commit d59c7c2ff30dc028dda0ea028049552550c5b460
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Tue Jan 29 13:57:51 2013 -0800

    net: wireless: bcmdhd: Update to version 5.90.195.114
    
    - Get AP beacon and DTIM to set proper DTIM skipping
    
    Change-Id: I6bc23f050c144bf8361078ad587bcadbfe3a37fc
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 2ded2915fa7d7e4872294b8898a89f7d91e435c0
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Tue Jan 15 15:16:31 2013 -0800

    net: wireless: bcmdhd: Fix PEAP with dynamic WEP
    
    Change-Id: I62dffdb3b759ea5ccdf9f7ea0f0e67f928ace92b
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 037bc6677de61327e5f895935309b92aa8c4629d
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Tue Dec 18 14:43:34 2012 -0800

    net: wireless: bcmdhd: Postpone taking wd_wake lock
    
    Change-Id: I3926d7a1a357d173144f408996f35f0929db711e
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 0381d631b4d6501970c15701fb4e5bec52c6676a
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Tue Nov 27 12:57:32 2012 -0800

    net: wireless: bcmdhd: Increase PNO wakelock to 7 sec
    
    Change-Id: Ife7bac08d16e19b37d16f697e4ad9765ca6efbb7
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 10b153e7b9e30f5d4bc4129d895c04f51ea524b2
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Fri Nov 2 09:38:42 2012 -0700

    net: wireless: bcmdhd: Avoid suspend on watchdog
    
    Change-Id: Ic41a8f369a2ee8b2a0084e6a1cbf6b454ff53353
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 55d490b168c7bbfe8dd7c9c5db2952d57de5db8a
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Tue Jan 29 14:41:02 2013 -0800

    Revert "Revert "net: wireless: bcmdhd: Fix WD wakelock behavior""
    
    This reverts commit 22b4fcde206e96f57bf0a111403fc3d75532918a.

commit 42ee78807d9393691a8ff3f07207209e8d683814
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Tue Dec 18 21:20:01 2012 +0800

    driver: ril: check the modem hang pin when the system resume.
    
    Change-Id: I61e17df16260cc9434d60cf84e6d4ac3ba3addd7

commit e993409a412280a529210b01482ed0a1182fbcc9
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Fri Dec 7 18:00:39 2012 +0800

    arch: arm: xmm: Update the baseband xmm power state for the race condition issue.
    
    Avoid the L3 and then get the modem interrupt to generate CP L2 -> L0 issue
    because the baseband xmm power state was updated.
    
    Change-Id: Ic4a2147102b80635dadc75a7ea1abb39baf53e44

commit 53ea112e11b0a890ccd46b4f0fe68c45734613d6
Author: Ken Chang <kenc@nvidia.com>
Date:   Wed Sep 26 12:07:04 2012 +0800

    arm: tegra: usb_phy: disable PMC mode for USB1
    
    Both ehci host and udc device are registered on USB1. Thus we
    have both device and host mode phy for USB1.
    In this case, when we back from LP0, utmi_phy_power_on()
    were called twice, one for device mode and the other for host mode.
    For the device mode, it's called by fsl_udc_resume() then the phy
    is turned off right after the udc driver detected the id pin is low
    (we are working on host mode). However, the PMC is enabled for
    usb1 now by calling utmip_powerdown_pmc_wake_detect(), which
    is call by utmi_phy_power_off().
    
    PMC mode needs to be disabled to switch the pin control back to the
    host controller.
    
    bug 984119
    
    Change-Id: I7bcce88cf5f42e0cbf3ee2d0cc24bbcadf3d51e9
    Signed-off-by: Ken Chang <kenc@nvidia.com>

commit 09a0c1dc48774f98d2ac960372499f26a49bc0d8
Author: pomelo_hsieh <pomelo_hsieh@asus.com>
Date:   Mon Dec 17 15:46:37 2012 +0800

    Revert "This is to workaround that the bits USB_VBUS_INT_EN, USB_VBUS_WAKEUP_EN, USB_ID_INT_EN"
    
    This reverts commit 714b6a0dbdacfdc54dd607864c23ca4aaf1aed1c.

commit f6afcdbbd3243e74dfee74d13e2e6ef47bfc03b3
Author: pomelo_hsieh <pomelo_hsieh@asus.com>
Date:   Mon Dec 17 15:47:12 2012 +0800

    Assign the default value to the interrupt register variable.
    
    This is to avoid that the unknown value is restored in resuming if the system failed to suspend.
    
    Change-Id: I22e19c9e9def26afa9a104043abddd9ad6b45b79

commit 5fd8a6275afee6ef0e2b076087ceaaf8adc413b5
Author: adogu <adogu_huang@asus.com>
Date:   Thu Oct 25 17:22:49 2012 +0800

    Camera: fine-tune mi1040 power sequence.
    
    Change-Id: I6d9b8710a0c6c685252a36f2ca7957aadf923221

commit 05b777c19883248ea341945a243ddb64859cd3e7
Author: tryout_chen <tryout_chen@asus.com>
Date:   Thu Nov 15 14:32:21 2012 +0800

    Proximity: Enable sensor by it's previous RIL setting when device resume from suspend.
    
    Change-Id: Id5b0bfaa79d62e5c41fa704470cf82bf7a0fefac

commit 8722d5e9b3d4bc96d433148d05334823631a645b
Author: Haley Teng <hteng@nvidia.com>
Date:   Wed Nov 28 17:29:28 2012 +0800

    video: tegra: host: better error handling in alloc_gathers()
    
    We should return -ENOMEM in alloc_gathers() when get a NULL pointer
    from nvmap_alloc() or nvmap_mmap()
    
    Bug 1178135
    
    Change-Id: I29321710343983a6e733d95b10a1f7eb586246c0
    Signed-off-by: Haley Teng <hteng@nvidia.com>

commit 110f581ded86c64c0a3ce4884daf3046a6395b2e
Author: Jithu Jance <jithu@broadcom.com>
Date:   Thu Nov 15 17:14:20 2012 -0800

    net: wireless: bcmdhd: Enable P2P probe request handling only during discovery
    
    Change-Id: I2db29d5ed7f66f2a45feb890c81d510fcad24dd2
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 22b4fcde206e96f57bf0a111403fc3d75532918a
Author: Ramanan Rajeswaran <ramanan@google.com>
Date:   Fri Nov 2 10:29:13 2012 -0700

    Revert "net: wireless: bcmdhd: Fix WD wakelock behavior"
    
    This reverts commit 87576b83c90b58e976192e267274353c88dc5638.

commit f4d9951889686ea215f2ba46d311d36cdf7fcf8b
Author: Kees Cook <keescook@chromium.org>
Date:   Fri Oct 19 18:45:53 2012 -0700

    use clamp_t in UNAME26 fix
    
    The min/max call needed to have explicit types on some architectures
    (e.g. mn10300). Use clamp_t instead to avoid the warning:
    
      kernel/sys.c: In function 'override_release':
      kernel/sys.c:1287:10: warning: comparison of distinct pointer types lacks a cast [enabled by default]
    
    Reported-by: Fengguang Wu <fengguang.wu@intel.com>
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 96b669392f664d349142c53d15b5c05fcd98853e
Author: Kees Cook <keescook@chromium.org>
Date:   Fri Oct 19 13:56:51 2012 -0700

    kernel/sys.c: fix stack memory content leak via UNAME26
    
    Calling uname() with the UNAME26 personality set allows a leak of kernel
    stack contents.  This fixes it by defensively calculating the length of
    copy_to_user() call, making the len argument unsigned, and initializing
    the stack buffer to zero (now technically unneeded, but hey, overkill).
    
    CVE-2012-0957
    
    Reported-by: PaX Team <pageexec@freemail.hu>
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Cc: Andi Kleen <ak@linux.intel.com>
    Cc: PaX Team <pageexec@freemail.hu>
    Cc: Brad Spengler <spender@grsecurity.net>
    Cc: <stable@vger.kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 4495fa38dbb83379bdb504f4c8dcbcf0e9d24e1e
Author: andy2_kuo <andy2_kuo@asus.com>
Date:   Thu Oct 25 18:38:21 2012 +0800

    net: wireless: bcmdhd: Prevent HT Avail timeout to frozen deice while asleep.
    
    Change-Id: I6ccd035539a3a3074b7ff1e06854ce396d784fc4

commit 87576b83c90b58e976192e267274353c88dc5638
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Tue Oct 23 11:39:40 2012 -0700

    net: wireless: bcmdhd: Fix WD wakelock behavior
    
    Change-Id: I7ebae2be248cbb4bc98e2b448641f65b77a320f4
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
    
    Conflicts:
    
    	drivers/net/wireless/bcmdhd/dhd_linux.c

commit d5d2033ca465e5587cc7936d62df32dfb51b3fbb
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Wed Oct 24 13:14:48 2012 -0700

    net: wireless: bcmdhd: Fix BSSID report for disassoc
    
    Change-Id: I5e3b01a1a471e5983ab934fc9d65802a389ab1af
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit c8e1f6c79b3c0eb5e928e57aef85fb21935eab4b
Author: Tsechih_Lin <Tsechih_Lin@asus.com>
Date:   Thu Oct 25 23:55:23 2012 +0800

    Fix al3010 power on fail in late_resume function
    
    When interval time is too short between al3101_early_suspend() and al3010_late_resume().
    It will cause driver fail to set power on. So , add 5ms delay to fix this issue.
    
    Change-Id: I2523b41384b47cbb23100fdf7f451f54bdeaed19

commit b61598cfb7054b06e1e3c1252e7433b2c71e0e3a
Author: Joseph Wu <joseph_wu@asus.com>
Date:   Thu Oct 25 18:08:55 2012 +0800

    Sensors: Revise compass compensation mechanism to fix non-linear issue.
    
    Revise the equation of compass compensation to
    make the data moving curve more linear when rotating.
    This fixes that the Orientation data variation doesn't match the degrees
    that the device actually has been rotated.
    
    Bug: 7395562
    Change-Id: Ib628920066adc8250e901a40e69ee5fc2364298c

commit 9347a7121acfe73a0ca6106c6c5755749bda7ba1
Author: Simon Wilson <simonwilson@google.com>
Date:   Fri Oct 26 15:26:02 2012 -0700

    ASoC: tegra: headset: improve dock switch code
    
    Remove all audio routing and use two switch devices
    to signal userspace of dock changes. Routing can
    then be done in userspace for the dock.
    
    Change-Id: Id73a5ea6754a780897bc23aec02157749a3a5fd6
    Signed-off-by: Simon Wilson <simonwilson@google.com>

commit 52002b6c39df95fa7c82b07fe1ab9e158f687af2
Author: Simon Wilson <simonwilson@google.com>
Date:   Fri Oct 26 16:34:13 2012 -0700

    Revert "ASoC: codec: rt5640: change lineout route to output mixer and set path gain to -1.875dB."
    
    This reverts commit 2a6888f052b9fdcadbc6ea13415f35ce5caa9dbc.
    
    Change-Id: Idcf6de88a3789210336d6cf3f3519d2d0fa7aa98

commit b60bdf03636e5d88af73fbbffc3013d473e32c32
Author: Simon Wilson <simonwilson@google.com>
Date:   Fri Oct 26 10:56:23 2012 -0700

    Revert "7377546 Add dock switch device to support daydream mode."
    
    This reverts commit e8ee95ced1d5d7cff90074589066b6f82145342b.
    
    Change-Id: I12f7deb0eab18b712ff0cdb1c3274a23664c5c9d

commit e8ee95ced1d5d7cff90074589066b6f82145342b
Author: jerryyc_hu <jerryyc_hu@asus.com>
Date:   Wed Oct 24 18:37:26 2012 +0800

    7377546 Add dock switch device to support daydream mode.
    
    Nakasi should start Sleep Mode / Dream when placed in Dock
    
    Change-Id: I7545377b7a4e5e6d52d0208af6ac3f7bb2fd86e3

commit 541cdd8f4054ee83b53eaecac360a712627d9acf
Author: Joseph Wu <Joseph_Wu@asus.com>
Date:   Tue Oct 23 13:08:54 2012 +0800

    Sensors: Fix an improper type definition when loading compass gain.
    
    To load compass gain with a correct type, we should fix it to 'int'.
    This should be common fix but partial related to bug 7355959.
    
    Bug: 7355959
    
    Change-Id: I3514618a47cedd5354d1d4b26d30a8026e02e6f3

commit 1b997b79c2f7baedef1abca52e379a90889bc6df
Author: able_liao <able_liao@asus.com>
Date:   Tue Oct 23 20:12:21 2012 +0800

    SoC: tegra: headset: fix speaker silent issue after inserting and removing headset rapidly.
    
    Speaker could get silent if insert and remove headphone rapidly,
    or even just normally insert and remove headphone during system suspend.
    
    The "AUX" and "speaker" dapm mixer control was for dock function but causes such issue,
    now remove them from kernel and redesign in HAL to satisfy both audio and dock functions.
    
    Bug: 7388692
    Change-Id: Iaa2dc40575ee3a6c9ddcd49f5dd1a92e94c20655
    Signed-off-by: able_liao <able_liao@asus.com>

commit 713d450502d06d81971b99b968a16b225fbdca29
Author: lucien_wu <lucien_wu@asus.com>
Date:   Sat Oct 20 01:35:32 2012 +0800

    Power on/off sequence tuning for Himax T-con IC
    
    Change-Id: I908e0b1233f4951c92d49b952a94f9e285c24424

commit 97d6c21b6d099d4bf08af0a739aefb035aa64859
Author: Haley Teng <hteng@nvidia.com>
Date:   Thu Oct 18 08:04:28 2012 +0800

    arm: tegra: grouper: setup uart_c as bluetooth uart port for bluesleep
    
    Signed-off-by: Haley Teng <hteng@nvidia.com>

commit 74fd39c7249ff1e6c2ecf4a53c455c847789d29b
Author: Haley Teng <hteng@nvidia.com>
Date:   Thu Oct 18 07:54:51 2012 +0800

    bluesleep: implement to support bluedroid
    
    "#define BT_BLUEDROID_SUPPORT 1" -> support BlueDroid
    "#define BT_BLUEDROID_SUPPORT 0" -> support BlueZ
    
    Since BlueDroid does not use kernel space HCI driver now, we add the
    below 2 /proc nodes to make BlueDroid able to send HCI events to
    bluesleep driver.
    
    write 1 to /proc/bluetooth/sleep/lpm -> equivalent to HCI_DEV_REG event
    write 0 to /proc/bluetooth/sleep/lpm -> equivalent to HCI_DEV_UNREG event
    write 1 to /proc/bluetooth/sleep/btwrite -> equivalent to HCI_DEV_WRITE event
    
    Signed-off-by: Haley Teng <hteng@nvidia.com>

commit 88cfebcb20c669a8cff3216b9cb4c1f5995de23a
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Fri Oct 19 20:24:37 2012 +0800

    arch: arm: xmm: repeat to push the crash pin and force to change the crash mode.
    
    Change-Id: I04b6ae83efe8a99baefe20e2a623731fbfb8bb7d

commit 581cd08c178b714571c356827c6a5b9c8985c9d3
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Wed Oct 17 19:55:40 2012 +0800

    drivers: usb: core: reduce the resume time for HSIC controller.
    
    Change-Id: If7123e444410babd4a04abeaf471098dfb026db1

commit 2c4f963efe58272c6560f346e42805eea2efb4b2
Author: Roger Hsieh <rhsieh@nvidia.com>
Date:   Wed Oct 3 12:39:04 2012 +0800

    arm: tegra: grouper: Increase MC_EMEM_ARB_OUTSTANDING_REQ to resolve underflow in low emc freq.
    
    New outstanding request is updated in the emc dvfs table:
    * 25.5Mhz: 20
    * 51Mhz: 20
    * 102Mhz: 30
    
    Bug 1057414
    
    Change-Id: I4d72b0db586ad99d6a6758737d87b3f68e6a47c4
    Signed-off-by: Haley Teng <hteng@nvidia.com>

commit 3c05088e8935929b1820c1a805a4e2008e1129c9
Author: Ramanan Rajeswaran <ramanan@google.com>
Date:   Mon Oct 15 16:17:15 2012 -0700

    Revert "Asoc: codec: rt5640: increase lineout output gain +1.875dB for B-dock sample."
    
    This reverts commit 273ea66a1a14f9b5c454a0ff8c2e8bdd22ee80b7
    
    Change-Id: I9cb92323299d17806aed5439ccf9c3c6798bce59

commit 273ea66a1a14f9b5c454a0ff8c2e8bdd22ee80b7
Author: able_liao <able_liao@asus.com>
Date:   Fri Oct 12 15:04:12 2012 -0700

    Asoc: codec: rt5640: increase lineout output gain +1.875dB for B-dock sample.
    
    1.where measure result:
      Vrms:0.242 V
      Vp-p:0.724 V
    
    Change-Id: I3e17671bebe0fea0e5a64d3b287e7c86a29ab7c1

commit b98092761997ffaa4232e0ab14326070954da1fc
Author: sam_chen <sam_chen@asus.com>
Date:   Thu Oct 11 14:44:43 2012 +0800

    ASoC: codecs: rt5642: fix whoosh noise when making the first click sound.
    
    Stable VREF by increasing VREF charging time in fast mode to 10-15ms (was: 5-6ms).
    
    Bug: 7257448
    Change-Id: I089821b886b4a4e92fa8fdafcc11bb0269c7fb05
    Signed-off-by: able_liao <able_liao@asus.com>

commit efba26de4a6b5a9432494dd2aa76139ec0845d49
Author: tryout_chen <tryout_chen@asus.com>
Date:   Wed Oct 3 22:36:39 2012 +0800

    Proximity: Fix reports status change frequently even when not moving.
    
    Bugnizer ID: 7267739
    
    Change-Id: I4ffac18b3266c323f22f8014fbf2cdf2caa048a5

commit afd49a4a2315e8c073bc979ffbdd89454058d84c
Author: Raphanus Lo <raphanus_lo@asus.com>
Date:   Mon Oct 1 11:25:00 2012 -0700

    tilapia: arm: xmm: improve log when illegal L2->L0 occurs.
    
    Change-Id: I7e1da2efbe5690f4b3a999506c4a22fb8017ad45

commit c3931b37b0f545a299b355ec4e8a6cd7b3cbdd52
Author: jerryyc_hu <jerryyc_hu@asus.com>
Date:   Fri Sep 28 19:42:25 2012 +0800

    7182768 Hold a wake lock when cable plug in or out.
    
    [Bach]Unable to wakeup DUT when plug or unplug charger or USB cable (3/10 of occurrence)
    
    Change-Id: I2d0cfe7b22139ef74ed46857dc4782cf09a0fc54

commit 86381cccab94d4030901d3d5d192722f2694615b
Author: Raphanus Lo <raphanus_lo@asus.com>
Date:   Sun Sep 30 19:38:20 2012 -0700

    tilapia: arm: xmm: Do not update illegal L2->L0 state.
    
    Do not override XMM power state when it tend to get L2->L0 from any
    state other than L2.
    
    Bugnizer ID: 7243198
    
    Change-Id: I54d50eff89f0a44dd33d6ee1821f9ef5b5efe764

commit d06cf594594800fa12b5d0ed5bd5abe0d2ad462a
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Mon Oct 1 10:27:51 2012 +0800

    tilapia: USB: HSIC: disable the remote wakeup irq
    
    Change-Id: I3b6054bf33143ff328d3976a2c482e691a60b6e6

commit 19b48ce2d77fceb497fcfaf4fb842a698a62aa51
Author: Joseph Wu <Joseph_Wu@asus.com>
Date:   Mon Oct 1 20:31:54 2012 +0800

    Sensors: Update compass compensation in sensors' driver.
    
    - Based on mpl v5.1.0.
    - It would not affect the performance about e-compass.
    - Supoort both grouper/tilapia.
    - Add more debug message.
    - cat ../iio:device1/compass_cali_test to perform this command.
    Signed-off-by: Joseph Wu <Joseph_Wu@asus.com>
    
    Change-Id: I230a6e55875d01cb607ddf3903152cc69770b0ec

commit 74ae38d84cf2502ca3235d04ffe76cbe386908b5
Author: Joseph Wu <Joseph_Wu@asus.com>
Date:   Mon Oct 1 10:34:09 2012 +0800

    Revert "Sensors: [PATCH 1/3] Invensense 5.1.2 IIO driver release."
    
    This reverts commit 08f02f8bba6ec3613a3ca3d19e1a07f67739bdd4.

commit eb72d0308d4f46ff106f7097a3c040cfda83733d
Author: Joseph Wu <Joseph_Wu@asus.com>
Date:   Mon Oct 1 10:32:07 2012 +0800

    Revert "Sensors: Some minor updates for sensors iio structure."
    
    This reverts commit 3de11fe53273ddc7bef83f013fc5c5a1fe9fb937.

commit 857dcabb282e17e847dfa63ca5e4d7753e117cb8
Author: Joseph Wu <Joseph_Wu@asus.com>
Date:   Mon Oct 1 10:26:47 2012 +0800

    Revert "Sensors: Checking compass compensation from factory calibrated gain."
    
    This reverts commit a113725524b6d5261bdc5053a1b5ac66915b8f0a.

commit 72437e9c4baf949dab67724512ac778fb5703e34
Author: Colin Cross <ccross@android.com>
Date:   Wed Sep 26 14:21:22 2012 -0700

    timekeeping: fix 32-bit overflow in get_monotonic_boottime
    
    get_monotonic_boottime adds three nanonsecond values stored
    in longs, followed by an s64.  If the long values are all
    close to 1e9 the first three additions can overflow and
    become negative when added to the s64.  Cast the first
    value to s64 so that all additions are 64 bit.
    
    Change-Id: Ic996d8b6fbef0b72f2d027b0d8ef5259b5c1a540
    Signed-off-by: Colin Cross <ccross@android.com>

commit ef2f75b5c178b73bd0b754e9d1582649323cc079
Author: able_liao <able_liao@asus.com>
Date:   Thu Sep 27 18:46:31 2012 +0800

    Audio:fix music playing through speaker instead of the headset when reboot DUT
    
    1.if we insert wired headset and reboot DUT,it will playback by speaker instead of headset.
      It reason is lineout_gpio pin will be detected earlier than it is enabled and requested
      at initial boot,so it will detect wrong status to debug board.
      In this situation lineout_gpio is 0 when detection work at initial boot.
    2.Modify lineout_gpio is enabled and requested earlier than detection work.
      we can improve this issue.
    
    Bugnizer ID :7235478
    
    Change-Id: I368d6603ca39ea2367fe6ed8ee644445a770c024
    Signed-off-by: able_liao <able_liao@asus.com>

commit 3f478105c195f347209caed6b0b594502951ef4a
Author: andy2_kuo <andy2_kuo@asus.com>
Date:   Tue Sep 25 16:24:40 2012 +0800

    Revert "arm: tegra: kai: read mac address from board eeprom"
    
    This reverts commit 8f9962bcd76bd29d8e773af6bbae3817886d4302.
    
    Change-Id: I529de950411d55931f06ad8b7d4b80c9e6d71c26

commit 5c6426d0ea1ae8b9c617afe2dd8176ec1818653f
Author: Ban_Feng <Ban_Feng@asus.com>
Date:   Wed Sep 26 10:44:07 2012 +0800

    mmc: card: Bypass discard for Hynix and Kingston
    
    In order to change mount option,
    issuing discard request by chip to eliminate performance drop.
    
    Bug ID: 7158066
    
    Change-Id: Ia55bce8ae29c1751f180d76164e1ac1753af89f0

commit 4acc227edfb631d377e14911287c1b73682fc9c2
Author: singhome_lee <singhome_lee@asus.com>
Date:   Thu Sep 20 13:54:43 2012 +0800

    mmc: core: new discard feature support at Samsung eMMC v4.41+.
    
    Support discard feature if MID field in the CID register is 0x15, EXT.CSD[192]
    (device version) is 5 and Bit 0 in the EXT.CSD[64] is 1. Also removed REQ_SECURE flag
    check to avoid kernel hang.
    
    This patch is released from samsung.
    
    Change-Id: I4023a900680e9bca10c40311b09ed077a22617db

commit 3de11fe53273ddc7bef83f013fc5c5a1fe9fb937
Author: issac_wu <issac_wu@asus.com>
Date:   Wed Sep 26 17:41:53 2012 +0800

    Sensors: Some minor updates for sensors iio structure.
    
    - add DMP and motion checking function for testing
    - Provided by Invensense.
    
    Change-Id: I116cb31c89f1a03f1c85baf6e6b1dee34eb65e22
    Signed-off-by: issac_wu <issac_wu@asus.com>

commit a113725524b6d5261bdc5053a1b5ac66915b8f0a
Author: Joseph Wu <Joseph_Wu@asus.com>
Date:   Fri Sep 21 22:36:05 2012 +0800

    Sensors: Checking compass compensation from factory calibrated gain.
    
    - In order to check the compass raw data has been multiplied by gain
      that calibrated in factory, we create a new sysfs function to check it.
    - It would not affect the performance about e-compass.
    - Supoort both grouper/tilapia.
    - cat ../iio:device1/compass_cali_test to perform this command.
    
    Change-Id: I760a2947060319921c73c61e339cb85b9c83bab8
    Signed-off-by: Joseph Wu <Joseph_Wu@asus.com>

commit 40ae87f4e3208beabb8810bed7cff66a0a78c4e9
Author: tryout_chen <tryout_chen@asus.com>
Date:   Wed Sep 26 14:37:12 2012 +0800

    Proximity: Fix improper object detect status checking.
    
    This improper checking may cause sensing result unstable.
    
    Change-Id: Ib9c45c9df31f102f106d202c70638d87272b71a9

commit 16cbbbe8ea08e53eda71947b529056a26eb2d364
Author: ScottPeterson <speterson@nvidia.com>
Date:   Fri Sep 7 15:22:58 2012 -0700

    asoc: codec: Reduce audio codec warmup time
    
    Change-Id: I0cdccd58e2f5acd2b07a154d516ccc6ca785cce9
    Signed-off-by: Glenn Kasten <gkasten@google.com>

commit 4c88690fa581510222c67be8876e7dc43eb13fdb
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Fri Sep 21 06:27:07 2012 +0800

    arm: XMM: Waiting the ap wake pin to falling is needed before got falling.
    
    Change-Id: I6c9a535d3d0cb86a1eaaff79a658637235fe0b5c

commit 08f02f8bba6ec3613a3ca3d19e1a07f67739bdd4
Author: Joseph Wu <Joseph_Wu@asus.com>
Date:   Fri Sep 21 22:12:28 2012 +0800

    Sensors: [PATCH 1/3] Invensense 5.1.2 IIO driver release.
    
    - New driver with mpl v5.1.2 is released.
    - Provided by Invensense.
    
    Change-Id: Ib2a3da126ed7cf9b6b2397509c04044db635337e
    Signed-off-by: Joseph Wu <Joseph_Wu@asus.com>

commit ac09366e1cb9c980acdc338e758d50f12db6ba21
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Fri Sep 21 06:07:54 2012 +0800

    arm: xmm: Pull the DAP1_DIN to force the modem crash
    
    Change-Id: I0ff48fd1ff9c6cc4834656dd8ef53388fc4bf96a

commit 1da655b8171b52c80b82109676ae48783f44c28d
Author: jerryyc_hu <jerryyc_hu@asus.com>
Date:   Mon Aug 27 22:10:20 2012 +0800

    7195738 Add the error handling for temperature/voltage gauge reading wrong.
    
    temperature/voltage may read wrong if i2c is busy.
    
    Change-Id: I0c459b3684f264bde0fc1456dd452c3ecdc26e84

commit a85f646dc9429cfc288875f48eca47bbfa6439f2
Author: jerryyc_hu <jerryyc_hu@asus.com>
Date:   Fri Sep 21 16:45:36 2012 +0800

    7151054 To shutdown the system while battery capacity is low.
    
    To avoid battery being drained to critial low state,
    nakasi needs a change to shutdown device while "AC/USB is charging" and battery=0%.
    
    Change-Id: I52bc0f77000fdcb0f29450c1eae963462ffb4351

commit 8b0a6ebd0da45c46418a579b308c4f61b73b6538
Author: tryout_chen <tryout_chen@asus.com>
Date:   Mon Sep 17 21:38:45 2012 +0800

    Proximity: Enable Proximity Sensor Cap1106.
    
    Change-Id: Iac74824d9270f06cfb36dc5d18f0904cd79d11c6

commit e589947e53f8e9755268af12762d162b09bacc62
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Thu Sep 20 11:33:09 2012 -0700

    net: wireless: bcmdhd: Adjust roaming treshold to -65 dB
    
    Change-Id: I88bb0cf759ee4262f31f054ef2dd5fc6258e8628
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 307a3a0beb16203076f8c6708da724833c461cba
Author: sam_chen <sam_chen@asus.com>
Date:   Thu Sep 20 16:56:59 2012 +0800

    ASoC: tegra: headset: Fix debugboard detection fail on Bach ER2.
    
    On bach ER2, hardware revision changes to 0(GROUPER_PCBA_SR3),
    and we discard headphone/uart switch on Nakasi GROUPER_PCBA_SR3 which
    hardware is not supported switch.
    To make debug board work on Bach ER2, remove GROUPER_PCBA_SR3 related codes.
    
    Change-Id: I6f12127c549919b9823c4951367d53785e3fb178
    Signed-off-by: sam_chen <sam_chen@asus.com>

commit f224107e4d600959c4b6d257f03dc13c9c61a641
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Thu Sep 20 06:47:26 2012 +0800

    RIL: Modem crash handler implementation.
    
    Change-Id: Id7e179f8e50b4ca12bfd0ebfcf9aa4b4edd10134

commit 1867bdbb74920d7dbf107cc2e5fa09d8de3cdc85
Author: able_liao <able_liao@asus.com>
Date:   Wed Sep 19 18:03:16 2012 +0800

    ASoC: codec: rt5640: Correct suspend/resume procedures to fix pop or silent issue.
    
    1.Once CONFIG_PM is defined, both rt5640_resume and rt5640_resume_i2c will be called
      within a short time when resuming. It possibly caused register write wrong value
      and resulted in pop sound or silent issues after resumed.
    
      In order to avoid this situation, drop function rt5640_suspend_i2c/rt5640_resume_i2c,
      and integrate all controls into rt5640_suspend/rt5640_resume
    
    Change-Id: I3b04bd46fc218bc13882e84dd0e624e1e17221aa

commit b5a6465cd07077019b72a3e193f826ce65d3f4f5
Author: Mark Zhang <markz@nvidia.com>
Date:   Mon Jul 2 13:05:25 2012 +0800

    video: tegra: dc: vblank worker
    
    Freeze vblank worker while suspending by adding the work into
    system freezewq. This eliminates a kernel panic caused by nvsd
    reading brightness valuesfrom display while clock gated.
    
    Bug 1006180
    Bug 1003969
    Bug 1003730
    Bug 999580
    
    Change-Id: Id93f4df23e380a7e14e888ebe5c8991e652eb0f9
    Signed-off-by: Mark Zhang <markz@nvidia.com>
    Signed-off-by: Haley Teng <hteng@nvidia.com>
    Reviewed-on: http://git-master/r/128892
    Reviewed-by: Prajakta Gudadhe <pgudadhe@nvidia.com>

commit e45710d9628a06b16938ba6e4868671a29472b0f
Author: Kevin Huang <kevinh@nvidia.com>
Date:   Wed Jun 20 13:17:00 2012 -0700

    video: tegra: dc: Skip the vblank_int work if DC is disabled.
    
    Bug 1000789
    Bug 1003730
    Bug 999580
    
    Signed-off-by: Kevin Huang <kevinh@nvidia.com>
    
    Conflicts:
    
    	drivers/video/tegra/dc/dc.c
    
    Change-Id: Ib0419e6792edfe1fe15bd010da812fc040c25f6e
    Signed-off-by: Haley Teng <hteng@nvidia.com>
    Reviewed-on: http://git-master/r/128891
    Reviewed-by: Prajakta Gudadhe <pgudadhe@nvidia.com>

commit 27f2bde15d350a7c20c106da987550cf2a692d1a
Author: Kevin Huang <kevinh@nvidia.com>
Date:   Fri Jun 8 16:15:55 2012 -0700

    video: tegra: dc: Use ref-count to mask vblank interrupt.
    
    Bug 990586
    Bug 999580
    
    Signed-off-by: Kevin Huang <kevinh@nvidia.com>
    
    Conflicts:
    
    	drivers/video/tegra/dc/dc.c
    	drivers/video/tegra/dc/dc_priv.h
    
    Change-Id: Iad64cd6349ab1281a632842efd318ca8414500a0
    Signed-off-by: Haley Teng <hteng@nvidia.com>
    Reviewed-on: http://git-master/r/128864
    Reviewed-by: Prajakta Gudadhe <pgudadhe@nvidia.com>

commit 1aa914372832bcc5cd99214bb5c4046257bddb7c
Author: hsuan-chih_chen <hsuan-chih_chen@asus.com>
Date:   Wed Sep 19 10:23:28 2012 +0800

    mmc: set emmc vcore voltage to 3.0V
    
    per EE's request, set eMMC core voltage to 3.0V.
    
    Change-Id: I710bf98a20a64100169a24d64bc7e0d968d65a83

commit cd3f11475ba0205aef2fa71b8b7325d04f8bbafa
Author: Raphanus Lo <raphanus_lo@asus.com>
Date:   Mon Feb 20 16:53:57 2012 +0800

    RIL: provide SIM hotplug freezing enable/disable interface to user space.
    
    Instead of automatically freeze handling hotplug state, we provide a
    sysfs "/sys/devices/virtual/ril/files/stop_hotplug_detect" to control
    it.
            value   meaning
            ------+---------------------
            1      detection freezed
            0      detection not freezed
    
    Change-Id: I4f7d255eeefbe46fd74a90a3b03cf7f0cd543ae6
    Signed-off-by: Raphanus Lo <raphanus_lo@asus.com>

commit d00c834e1e2c078ed7f17c8a74d9b8428acb2176
Author: Raphanus Lo <raphanus_lo@asus.com>
Date:   Mon Feb 13 20:49:51 2012 +0800

    RIL: Implement the function of SIM hot plug.
    
    Read TEGRA_GPIO_PW3 and write the SIM plug state to switch class
    "sim_plug" with the following content definition:
    
        value   meaning
        ------+--------------
         1      SIM absent
         0      SIM inserted
    
    This interrupt will notify modem to refresh SIM plug state.
    
    Change-Id: I6f3a653950b77f3b91a0dc17bdccba745282214e
    Signed-off-by: Raphanus Lo <raphanus_lo@asus.com>

commit 16a215f133a0792d758bf8291089085cee5586c4
Author: Raphanus Lo <raphanus_lo@asus.com>
Date:   Mon Jan 16 20:41:31 2012 +0800

    RIL: add ril driver for SIM detection functions for products with modem.
    
    This RIL driver is here for controlling (1) USB vbus state for
    debuging/testing (2) SIM card detection
    
    1. GPIO configurations for products with modem.
    2. Disable conflict pinmux settings when audio initilizing.
    2. Monitor TEGRA_GPIO_PW3(n_SIM_CD) for SIM detection. (not implemented yet)
    3. Export sysfses under /sys/devices/virtual/ril/files for controlling
       USB vbus / other RIL-related low-level functions.
    
    Change-Id: I998783d387d0c714fa988fbf333cf65d6b81227b
    Signed-off-by: Raphanus Lo <raphanus_lo@asus.com>

commit 8fe24ec68a15150f717e0040c74a9ea3295513f5
Author: jerryyc_hu <jerryyc_hu@asus.com>
Date:   Tue Sep 18 16:15:51 2012 +0800

    Use project id and pcb id to support usb callback function.
    
    Change-Id: Ic027450a58e637b292a835d2209bec66d56b7106

commit 91fa195be994f092773ab47bfdce99ec310c59cf
Author: pomelo_hsieh <pomelo_hsieh@asus.com>
Date:   Tue Sep 18 19:55:48 2012 +0800

    To avoid the pcb_id been mixed between nakasi and bach.
    
    Change-Id: I901d3050ed090fff31053446c4fea721bc2322fa

commit b145753c6a62b4ca5528a738e55a32ac5a61bc58
Author: able_liao <able_liao@asus.com>
Date:   Mon Sep 17 17:43:58 2012 +0800

    Audio: enable UART cable detection and phone jack switch for developing projects
    
    1.switch GPIO_PW3 and GPIO-X.06 lineout detection pin(to detect UART cable) for nakasi and bach respectively.
    2.Now enable UART cable detection and phone jack switch for Bach and Nakasi TI SKU only,
      not including Nakasi Maxim SKU.
    
    Change-Id: Ic6115d7883a642579c06243cad5e0ed92b403d60

commit f0b850b521aec5b894bfd00a31a5318c87172b1a
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Tue Sep 18 07:19:31 2012 +0800

    arm: usb: xmm: Implement modem crash dump function for modem
    
    Change-Id: Iec184f7383e85fafea08ad84f50b88be1d883849

commit 96c46324c3c16f6d8f141e035f54f8e1721e23cd
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Tue Sep 18 03:22:01 2012 +0800

    Set the baseband_usb_chr driver as build-in and modify it for modem image downloading.
    
    1. Add TCGETS in baseband_usb_chr_ioctl.
    
    2. Remove the queue cycle of baseband_usb_chr_work, and add queue_work when the device has been probed.
       This will avoid that the delay in baseband_usb_chr_work cause the devices cannot be found by controller.
    
    3. Init the usb of baseband_usb_chr while baseband_usb_driver_disconnect() is invoked to avoid the kernel panic.
    
    4. Return in the complete function of urb submition when urb->status is error code.
       This can avoid infinite loop when error occurs for urb submition.
    
    5. Add log tag "CHR" if debug is enabled.
    
    Change-Id: Id1a08afb9a56f62193bc80158f4b43e28b714814

commit 9adebe6f8a89893e31a1d17e7e681a74fae56ef7
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Tue Sep 18 02:54:36 2012 +0800

    arm: XMM: add the sysfs, download modem and recovery modem functions.
    
    xmm_dwd_reset: reset modem to open hsic download mode.
    xmm_nml_reset: reset modem to recovery modem.
    
    Change-Id: I230cd01498c4e33e0bb7784b88e2f37e251dd705

commit 06b8ab31bf7b3daf31f619d1e3d23e1e5c14a9cf
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Mon Sep 17 11:37:52 2012 -0700

    net: wireless: bcmdhd: Add print when power-save mode is OFF
    
    Change-Id: Idc72198b2d59c76dd45ba918cef982bcd7b570ab
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 2aaa2316864cc241bcc69eaabcb048b6c65dbd9b
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Sun Sep 16 14:35:23 2012 -0700

    net: wireless: bcmdhd: Update wifi stack ps state if was changed
    
    Change-Id: Ib1ee0b6ee05077d1ed6cfb578b6384dfc9787c81
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
    
    Conflicts:
    
    	drivers/net/wireless/bcmdhd/wl_cfg80211.h

commit b37b852346ee04f9efb457e4fb586d7c705b3d4c
Author: yi-hsin_hung <yi-hsin_hung@asus.com>
Date:   Sat Sep 15 07:56:41 2012 +0800

    Change the dock_in_pin dynamicly by grouper_get_project_id.
    
    Change-Id: Ib9660b81eeb58640eeb64d136a1c0b1b81f36e2b

commit 8338fad3260b8c5a9a59d0ac0ba2b70593a7b862
Author: sam_chen <sam_chen@asus.com>
Date:   Wed Sep 12 09:27:50 2012 +0800

    ASoC:tegra:Correct left/right channel of audio dock lineout output.
    
    Fix the issue that changing the routing path from pad-speaker to dock-lineout causes L/R channel reversed.
    
    Change-Id: Iddc0608e4d625cf26c9c29419528f6b5f11bdf53
    Signed-off-by: sam_chen <sam_chen@asus.com>

commit feb286fcb903c04efd218235768b9f204058c8bb
Author: Ban_Feng <Ban_Feng@asus.com>
Date:   Wed Sep 12 15:34:51 2012 +0800

    eMMC: Configure LDO1 init_enable
    
    Based on EE's observation, at regulator init stage will
    drop the eMMC voltage around 1.1ms, which is unacceptable.
    So configuring the init_enable flag which makes LDO1 stable.
    
    Change-Id: I39e10a8817009cecb087b67a28d7342706cc194c

commit 45f3563caad95f4a51e6b3a6dea7060856f05248
Author: Dmitry Shmidt <dimitrysh@google.com>
Date:   Thu Sep 13 13:56:32 2012 -0700

    net: wireless: bcmdhd: Add ROAM setting per platform from Makefle
    
    Change-Id: Ia6bc3025e3641cb6b91022ab1c9976c0f6ad16a4
    Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>

commit 3fc2523b3f9761507b8174cf6d03d23dee3fc09d
Author: Will Deacon <will.deacon@arm.com>
Date:   Mon Aug 13 17:38:48 2012 +0000

    ARM: mutex: use generic atomic_dec-based implementation for ARMv6+
    
    Commit a76d7bd96d65 ("ARM: 7467/1: mutex: use generic xchg-based
    implementation for ARMv6+") removed the barrier-less, ARM-specific
    mutex implementation in favour of the generic xchg-based code.
    
    Since then, a bug was uncovered in the xchg code when running on SMP
    platforms, due to interactions between the locking paths and the
    MUTEX_SPIN_ON_OWNER code. This was fixed in 0bce9c46bf3b ("mutex: place
    lock in contended state after fastpath_lock failure"), however, the
    atomic_dec-based mutex algorithm is now marginally more efficient for
    ARM (~0.5% improvement in hackbench scores on dual A15).
    
    This patch moves ARMv6+ platforms to the atomic_dec-based mutex code.
    
    Change-Id: I6661faeadc634a55161726ceaa75b58c3c9ff6e7
    Cc: Nicolas Pitre <nico@fluxnic.net>
    Signed-off-by: Will Deacon <will.deacon@arm.com>
    Acked-by: Nicolas Pitre <nico@linaro.org>
