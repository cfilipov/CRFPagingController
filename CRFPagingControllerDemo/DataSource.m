//
//  CRFPagingController
//
//  Copyright (c) 2013, Cristian Filipov. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are
//  met:
//
//  1. Redistributions of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//
//  3. Neither the name of the Cristian Filipov nor the names of its
//     contributors may be used to endorse or promote products derived from
//     this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
//  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
//  TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
//  PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
//  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
//  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "DataSource.h"
#import "Person.h"

#define kFlagUSA         [UIImage imageNamed:@"us"]
#define kFlagUK          [UIImage imageNamed:@"uk"]
#define kFlagDutch       [UIImage imageNamed:@"netherlands"]
#define kFlagIsrael      [UIImage imageNamed:@"israel"]
#define kFlagCanada      [UIImage imageNamed:@"canada"]
#define kFlagSwitzerland [UIImage imageNamed:@"switzerland"]
#define kFlagLatvia      [UIImage imageNamed:@"latvia"]
#define kFlagIndia       [UIImage imageNamed:@"india"]
#define kFlagVenezuela   [UIImage imageNamed:@"venezuela"]
#define kFlagTaiwan      [UIImage imageNamed:@"taiwan"]
#define kFlagChina       [UIImage imageNamed:@"china"]
#define kFlagNorway      [UIImage imageNamed:@"norway"]
#define kFlagDenmark     [UIImage imageNamed:@"denmark"]
#define kFlagGreece      [UIImage imageNamed:@"greece"]
#define kFlagItaly       [UIImage imageNamed:@"italy"]

#define kCellReuseIdentifier @"DataCell"
#define kRowHeight           60

@implementation DataSource

- (id)init
{
    self = [super init];
    if (self)
    {
        self.data = [[NSMutableArray alloc] init];
        
        // Data and images from Wikipedia.
        self.dataToLoad = [[NSMutableArray alloc] initWithObjects:
                       [Person withName:@"Alan J. Perlis"      flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Alan_Perlis"                         blurb:@"IT, ALGOL"],
                       [Person withName:@"Maurice Wilkes"      flag:kFlagUK          url:@"http://en.wikipedia.org/wiki/Maurice_Wilkes"                      blurb:@"Microprogramming"],
                       [Person withName:@"Richard Hamming"     flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Richard_Hamming"                     blurb:@"Hamming code, Hamming window, Hamming numbers, Sphere-packing, Hamming distance, Association for Computing Machinery"],
                       [Person withName:@"Marvin Minsky"       flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Marvin_Minsky"                       blurb:@"Artificial intelligence"],
                       [Person withName:@"James H. Wilkinson"  flag:kFlagUK          url:@"http://en.wikipedia.org/wiki/James_H._Wilkinson"                  blurb:@"Numerical Analysis"],
                       [Person withName:@"John McCarthy"       flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/John_McCarthy_(computer_scientist)"  blurb:@"Artificial intelligence, Lisp; Circumscription, Situation calculus"],
                       [Person withName:@"Edsger W. Dijkstra"  flag:kFlagDutch       url:@"http://en.wikipedia.org/wiki/Edsger_W._Dijkstra"                  blurb:@"Dijkstra's algorithm, Structured programming, THE multiprogramming system, Semaphore"],
                       [Person withName:@"Charles Bachman"     flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Charles_Bachman"                     blurb:@"Integrated Data Store"],
                       [Person withName:@"Donald Knuth"        flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Donald_Knuth"                        blurb:@"The Art of Computer Programming, TEX, METAFONT, Knuth–Morris–Pratt algorithm, Knuth–Bendix completion algorithm, MMIX"],
                       [Person withName:@"Allen Newell"        flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Allen_Newell"                        blurb:@"Information Processing, Language, Soar"],
                       [Person withName:@"Herbert A. Simon"    flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Herbert_A._Simon"                    blurb:@"Logic Theory Machine, General Problem Solver, Bounded rationality"],
                       [Person withName:@"Michael O. Rabin"    flag:kFlagIsrael      url:@"http://en.wikipedia.org/wiki/Michael_O._Rabin"                    blurb:@"Miller-Rabin primality test, Rabin cryptosystem, Oblivious transfer, Rabin-Karp string search algorithm, Nondeterministic finite automata, Randomized algorithms"],
                       [Person withName:@"Dana Scott"          flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Dana_Scott"                          blurb:@"automata theory, semantics of programming languages"],
                       [Person withName:@"John Backus"         flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/John_Backus"                         blurb:@"Speedcoding, FORTRAN, ALGOL, Backus-Naur form, Function-level programming"],
                       [Person withName:@"Robert W. Floyd"     flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Robert_Floyd"                        blurb:@"Floyd–Warshall algorithm, Floyd–Steinberg dithering, Floyd's cycle-finding algorithm"],
                       [Person withName:@"Kenneth E. Iverson"  flag:kFlagCanada      url:@"http://en.wikipedia.org/wiki/Kenneth_E._Iverson"                  blurb:@"APL, J"],
                       [Person withName:@"Tony Hoare"          flag:kFlagUK          url:@"http://en.wikipedia.org/wiki/Tony_Hoare"                          blurb:@"Quicksort, Hoare logic, CSP"],
                       [Person withName:@"Edgar F. Codd"       flag:kFlagUK          url:@"http://en.wikipedia.org/wiki/Edgar_F._Codd"                       blurb:@"relational model, OLAP"],
                       [Person withName:@"Stephen Cook"        flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Stephen_A._Cook"                     blurb:@"NP-completeness, Propositional proof complexity, Cook-Levin theorem"],
                       [Person withName:@"Ken Thompson"        flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Ken_Thompson_(computer_programmer)"  blurb:@"Unix, B (programming language), Belle (chess machine), UTF-8, Endgame tablebase"],
                       [Person withName:@"Dennis Ritchie"      flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Dennis_M._Ritchie"                   blurb:@"ALTRAN, B, BCPL, C, Multics, Unix"],
                       [Person withName:@"Niklaus Wirth"       flag:kFlagSwitzerland url:@"http://en.wikipedia.org/wiki/Niklaus_Wirth"                       blurb:@"Algol W, Euler, Pascal, Modula, Modula-2, Oberon, Oberon-2, Oberon-07, Oberon System"],
                       [Person withName:@"Richard M. Karp"     flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Richard_M._Karp"                     blurb:@"Edmonds–Karp algorithm, Karp's 21 NP-complete problems, Hopcroft–Karp algorithm, Karp–Lipton theorem, Rabin–Karp string search algorithm"],
                       [Person withName:@"John Hopcroft"       flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/John_Hopcroft"                       blurb:@"Fundamental achievements in the design and analysis of algorithms and data structures"],
                       [Person withName:@"Robert Tarjan"       flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Robert_Tarjan"                       blurb:@"Algorithms and data structures"],
                       [Person withName:@"John Cocke"          flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/John_Cocke"                          blurb:@"RISC"],
                       [Person withName:@"Ivan Sutherland"     flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Ivan_Sutherland"                     blurb:@"Sketchpad, considered by many to be the creator of Computer Graphics"],
                       [Person withName:@"William Kahan"       flag:kFlagCanada      url:@"http://en.wikipedia.org/wiki/William_Kahan"                       blurb:@"IEEE 754, Kahan summation algorithm"],
                       [Person withName:@"Fernando J. Corbató" flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Fernando_J._Corbat%C3%B3"            blurb:@"A calculation of the energy bands of the graphite crystal by means of the tight-binding method (1956)"],
                       [Person withName:@"Robin Milner"        flag:kFlagUK          url:@"http://en.wikipedia.org/wiki/Robin_Milner"                        blurb:@"LCF, ML, Calculus of communicating systems, Pi-calculus, Hindley-Milner type inference"],
                       [Person withName:@"Butler Lampson"      flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Butler_W._Lampson"                   blurb:@"SDS 940, Xerox Alto"],
                       [Person withName:@"Juris Hartmanis"     flag:kFlagLatvia      url:@"http://en.wikipedia.org/wiki/Juris_Hartmanis"                     blurb:@"Introduced time complexity classes TIME (f(n)) and proved the time hierarchy theorem"],
                       [Person withName:@"Richard Stearns"     flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Richard_E._Stearns"                  blurb:@"Computational complexity theory"],
                       [Person withName:@"Edward Feigenbaum"   flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Edward_Feigenbaum"                   blurb:@"Artificial intelligence"],
                       [Person withName:@"Raj Reddy"           flag:kFlagIndia       url:@"http://en.wikipedia.org/wiki/Raj_Reddy"                           blurb:@"Artificial intelligence"],
                       [Person withName:@"Manuel Blum"         flag:kFlagVenezuela   url:@"http://en.wikipedia.org/wiki/Manuel_Blum"                         blurb:@"Complexity theory"],
                       [Person withName:@"Amir Pnueli"         flag:kFlagIsrael      url:@"http://en.wikipedia.org/wiki/Venezuela"                           blurb:@"Temporal logic, program and systems verification"],
                       [Person withName:@"Douglas Engelbart"   flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Douglas_Engelbart"                   blurb:@"Computer mouse, Hypertext, Groupware, Interactive computing"],
                       [Person withName:@"Jim Gray"            flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Jim_Gray_(computer_scientist)"       blurb:@"Database and transaction processing systems"],
                       [Person withName:@"Fred Brooks"         flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Frederick_P._Brooks"                 blurb:@"OS/360 The Mythical Man-Month"],
                       [Person withName:@"Andrew Yao"          flag:kFlagChina       url:@"http://en.wikipedia.org/wiki/Andrew_Chi-Chih_Yao"                 blurb:@"Theory of computation, complexity-based theory of pseudorandom number generation, cryptography, and communication complexity"],
                       [Person withName:@"Ole-Johan Dahl"      flag:kFlagNorway      url:@"http://en.wikipedia.org/wiki/Ole-Johan_Dahl"                      blurb:@"Simula, Object-oriented programming"],
                       [Person withName:@"Kristen Nygaard"     flag:kFlagNorway      url:@"http://en.wikipedia.org/wiki/Kristen_Nygaard"                     blurb:@"Simula, Object-oriented programming"],
                       [Person withName:@"Ron Rivest"          flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Ron_Rivest"                          blurb:@"Public-key encryption, RSA, RC2, RC4, RC5, RC6, MD2, MD4, MD5, MD6"],
                       [Person withName:@"Adi Shamir"          flag:kFlagIsrael      url:@"http://en.wikipedia.org/wiki/Adi_Shamir"                          blurb:@"RSA, Feige–Fiat–Shamir identification scheme, differential cryptanalysis"],
                       [Person withName:@"Leonard Adleman"     flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Leonard_Adleman"                     blurb:@"RSA, DNA computing"],
                       [Person withName:@"Alan Kay"            flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Alan_Kay"                            blurb:@"Dynabook, object-oriented programming, Smalltalk ,graphical user interface windows"],
                       [Person withName:@"Vint Cerf"           flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Vinton_G._Cerf"                      blurb:@"TCP/IP, Internet Society"],
                       [Person withName:@"Bob Kahn"            flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Robert_E._Kahn"                      blurb:@"TCP/IP"],
                       [Person withName:@"Peter Naur"          flag:kFlagDenmark     url:@"http://en.wikipedia.org/wiki/Peter_Naur"                          blurb:@"ALGOL, Backus–Naur Form"],
                       [Person withName:@"Frances E. Allen"    flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Fran_Allen"                          blurb:@"High-performance computing, parallel computing, compiler organization, optimization"],
                       [Person withName:@"Edmund M. Clarke"    flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Edmund_M._Clarke"                    blurb:@"Development of Model-Checking"],
                       [Person withName:@"E. Allen Emerson"    flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/E._Allen_Emerson"                    blurb:@"Development of Model-Checking"],
                       [Person withName:@"Joseph Sifakis"      flag:kFlagGreece      url:@"http://en.wikipedia.org/wiki/Joseph_Sifakis"                      blurb:@"Development of Model-Checking"],
                       [Person withName:@"Barbara Liskov"      flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Barbara_Liskov"                      blurb:@"Programming language and system design, distributed computing"],
                       [Person withName:@"Charles P. Thacker"  flag:kFlagUSA         url:@"http://en.wikipedia.org/wiki/Charles_P._Thacker"                  blurb:@"Xerox Alto, ethernet"],
                       [Person withName:@"Leslie Valiant"      flag:kFlagUK          url:@"http://en.wikipedia.org/wiki/Leslie_G._Valiant"                   blurb:@"Valiant–Vazirani theorem"],
                       [Person withName:@"Judea Pearl"         flag:kFlagIsrael      url:@"http://en.wikipedia.org/wiki/Judea_Pearl"                         blurb:@"Artificial Intelligence, Causality, Bayesian Networks"],
                       [Person withName:@"Silvio Micali"       flag:kFlagItaly       url:@"http://en.wikipedia.org/wiki/Silvio_Micali"                       blurb:@"Zero Knowledge Proof, Pseudorandom Functions"],
                       [Person withName:@"Shafi Goldwasser"    flag:kFlagIsrael      url:@"http://en.wikipedia.org/wiki/Shafi_Goldwasser"                    blurb:@"Cryptography, complexity theory"],
                       nil];
    }
    return self;
}

- (void)preload;
{
    NSUInteger nextPageSize = MIN(self.dataToLoad.count, self.pageSize);
    
    for (NSUInteger i = 0; i < nextPageSize; i++) {
        [self.data addObject:[self.dataToLoad objectAtIndex:i]];
    }
    
    [self.dataToLoad removeObjectsInRange:NSMakeRange(0, nextPageSize)];
}

- (void)load:(CRFPagingController *)dataSource;
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, self.loadDelay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        NSUInteger nextPageSize = MIN(self.dataToLoad.count, self.pageSize);
        
        for (NSUInteger i = 0; i < nextPageSize; i++) {
            [self.data addObject:[self.dataToLoad objectAtIndex:i]];
        }
        
        [self.dataToLoad removeObjectsInRange:NSMakeRange(0, nextPageSize)];
        [dataSource loadedNextPage:nextPageSize];
    });
}

#pragma mark CRFPagingTableControllerDelegate Methods

- (void)pagingControllerBufferNeedsNextPage:(CRFPagingController *)dataSource;
{
    [self load:dataSource];
}

- (void)pagingControllerDidTriggerNextPage:(CRFPagingController *)dataSource;
{
    [self load:dataSource];
}

- (BOOL)pagingControllerDoesHaveNextPage:(CRFPagingController *)dataSource;
{
    return self.dataToLoad.count > 0;
}

#pragma mark UITableViewDataSource Required Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellReuseIdentifier];
    }
    
    Person *person = [_data objectAtIndex:indexPath.row];
    cell.textLabel.text = person.name;
    cell.detailTextLabel.text = person.blurb;
    cell.imageView.image = person.flag;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return kRowHeight;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.data removeObjectAtIndex:indexPath.row];
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
}

@end
