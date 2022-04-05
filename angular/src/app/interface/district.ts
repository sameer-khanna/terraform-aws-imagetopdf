export interface District{
    state_id:number;
    district_id:number;
    district_name:string;
    state_name:string;
}

export interface Districts{
    districts: District[];
    ttl: number;
}