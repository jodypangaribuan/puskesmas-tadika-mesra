<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DoctorSchedule extends Model
{
    use HasFactory;

    protected $table = 'doctor_schedules';

    protected $fillable = [
        'doctor_id',
        'day_of_week',
        'start_time',
        'end_time',
        'cluster_id',
        'status',
    ];

    /**
     * Relationship with Doctor.
     */
    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }

    /**
     * Relationship with Cluster.
     */
    public function cluster()
    {
        return $this->belongsTo(Cluster::class);
    }

    /**
     * Get the day name from day_of_week.
     */
    public function getDayNameAttribute()
    {
        $days = [
            1 => 'Monday',
            2 => 'Tuesday',
            3 => 'Wednesday',
            4 => 'Thursday',
            5 => 'Friday',
            6 => 'Saturday',
            7 => 'Sunday',
        ];
        return $days[$this->day_of_week] ?? 'Unknown';
    }
}
