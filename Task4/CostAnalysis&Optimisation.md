# Cost Analysis & Optimisation

### Top3 Cost drivers
1. RDS (db.t3.medium Multi-AZ On-Demand)
2. NAT Gateway (1 AZ, 2TB data processed)
3. Data Transfer Out(3TB)

### Optimisation
1. RDS (db.t3.medium Multi-AZ On-Demand)
   - Since its DB better to choose Reservered Instance/Convertible Reserved Instance
   - Auto Scale Reader Instance according to the read traffic
   - Use compute Optimiser to find the right instance type
3. NAT Gateway (1 AZ, 2TB data processed)
   - Check if NAT Gateway is processing Cross Zone traffic too
   - If there are resources hosted in cross zone then switch to a Regional NAT Gateway or launch NAT Gateway in each region
5. Data Transfer Out(3TB)
   - Check for flow logs and see if data is traversed through NAT for connecting with internal services
   - Use Gateway Endpoints or Interface Endpoints if needed.
   - Use Cloud front to download frequently accessed data like ECS images
4. S3 (5TB storage + 10M GET requests)
   - Use Cloud Front infront of S3 to decrease traffic
   - Use transition rules to transfer objects to archive tier or antoher tier for objects which are not accessed frequently
   - If it has logs use delete object rules
6. ELB (ALB, 8 LCUs)
   - Use Cloud Front infront of ELB to reduce traffic  
2. EC2 (t3.medium On-Demand, 730hrs)
   - Use spot instances if its a batch process
   - Use Reserved Instances if its a long running application
   - If EC2 needs to be on demand, use auto shutdown in non bussiness hours
   - Use compute Optimiser to find the right instance type

We can use Compute Savings Plan which benefits for compute services to reduce cost

