//
// Copyright (C) 2003 Andras Varga; CTIE, Monash University, Australia
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program; if not, see <http://www.gnu.org/licenses/>.
//


package inet.linklayer.ethernet.switch;

import inet.linklayer.IMACRelayUnit;


//
// A ~IMACRelayUnit implementation which models one or more CPUs
// with shared memory, working from a single shared queue.
//
// It also models fixed delay for precessing each frame.
// Finite memory is taken into account by dropping frames if
// total number of bits enqueued exceed a given limit.
//
// A simple scheme for sending PAUSE frames is built in (although
// users will probably change it). When the buffer level goes
// above a high watermark, PAUSE frames are sent on all ports.
// The watermark and the pause time is configurable; use zero
// values to disable the PAUSE feature.
//
simple MACRelayUnitNP like IMACRelayUnit
{
    parameters:
        string addressTableFile = default("");  // see ~IMACRelayUnit
        int addressTableSize = default(100); // see ~IMACRelayUnit
        double agingTime @unit("s") = default(120s); // see ~IMACRelayUnit
        int numCPUs = default(1);  // number of CPUs
        double processingTime @unit("s") = default(0s);  // processing time of one frame
        int bufferSize @unit("B") = default(1MiB);  // memory
        int highWatermark @unit("B") = default(512KiB);  // buffer usage threshold to send PAUSE frame
        int pauseUnits = default(300);  // time to put in PAUSE frames (in units of 512 bit times)
        @display("i=block/switch");
        @statistic[usedBufferBytes](title="Used buffer bytes"; record=max,timeavg,vector);
        @statistic[processedBytes](title="Processed bytes"; record=count,sum,vector);
        @statistic[droppedBytes](title="Dropped bytes"; record=count,sum,vector);
    gates:
        input ifIn[] @labels(EtherFrame);
        output ifOut[] @labels(EtherFrame);
}

