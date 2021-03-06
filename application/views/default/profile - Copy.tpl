<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>HyperPVP - {$user->name}</title>
	
	<?php $this->inc("base/style"); ?>
	
  </head>
  <body>
  
    <div class="container">

		<?php
			$this->inc("base/links");
		?>
	
		<hr>
		
		<h3>{$user->name} <small>Last seen {$user->last_online} ago</small></h3>

		<hr>

		<div class="row">
		
			<div class="span3" width="100%" height="100%">
				<img src="https://minotar.net/helm/{$user->name}/158" class="img-rounded">
				<br>
				<br>
				
				<?php
							
				if ($this->data->user->rank != 0) {

					if ($this->data->user->rank == 3) {
						echo '<p><span style="margin-left:30px" class="label label-important">Administrator</span></p>';
					}
					
					if ($this->data->user->rank == 2) { 
						echo '<p><span style="margin-left:30px" class="label label-success">Moderator</span></p>';
					}

				}

				; ?>
				
				<p><strong>K/D Ratio: </strong>{$user->kdratio}</p>
				<p><strong>Cores Leaked: </strong>{$user->cores}</p>
                <p><strong>Monuments Broken: </strong>{$user->monuments}</p>
				
			</div>
			
			<div class="span3">
				<table class="table table-bordered">
					<tr>
						<td><h3>{$user->kills} <small>kills</small></h3></td>
					</tr>
					<tr>
						<td>
						
<?php

$i = 0;

foreach (UserDao::getStats($this->data->user->id, "kill") as $kill)
{
	$i++;
	
	if ($i > 25)
		break;
		
	$user = UserDao::getId($kill->to_id);
		
	echo "<a href='/profile/$user->username' rel='tooltip' style='display: inline-block;' title='$user->username'><img class='avatar' src='https://minotar.net/helm/$user->username/32.png' player='$user->username' style='width: 32px; height: 32px; margin-bottom: 2px; margin-left: 2px; margin-right: 2px;'/></a>";
}

?>
						<small><?php if ($i == 0) { echo "{$user->name} has not killed anyone!"; } else { echo "<br><br>{$user->name} killed"; } ?></small>
						</td>
					</tr>
				</table>

			</div>
			<div class="span3">
				<table class="table table-bordered">
					<tr>
						<td><h3>{$user->deaths} <small>deaths</small></h3></td>
					</tr>
					<tr>
						<td>
<?php

$i = 0;

foreach (UserDao::getStats($this->data->user->id, "death") as $death)
{
	$i++;
	
	if ($i > 25)
		break;
		
	$user = UserDao::getId($death->to_id);
		
	echo "<a href='/profile/$user->username' rel='tooltip' style='display: inline-block;' title='$user->username'><img class='avatar' src='https://minotar.net/helm/$user->username/32.png' player='$user->username' style='width: 32px; height: 32px; margin-bottom: 2px; margin-left: 2px; margin-right: 2px;'/></a>";
}


?>
						<small><?php if ($i == 0) { echo "{$user->name} has not been killed by anyone!"; } else { echo "<br><br>Killed {$user->name}"; } ?></small>
						</td>
					</tr>
				</table>

			</div>
			
			<div class="span3">
				<table class="table table-bordered">
					<tr>
						<td><h3>{$user->friends} <small>friends</small></h3></td>
					</tr>
					<tr>
						<td>
<?php

$i = 0;

foreach (UserDao::getFriends($this->data->username) as $friend)
{
	$i++;
	
	if ($i > 25)
		break;
		
	echo "<a href='/profile/$friend->friend' rel='tooltip' style='display: inline-block;' title='$friend->friend'><img class='avatar' src='https://minotar.net/helm/$friend->friend/32.png' player='$friend->friend' style='width: 32px; height: 32px; margin-bottom: 2px; margin-left: 2px; margin-right: 2px;'/></a>";
}


?>
						
						<small><?php if ($i == 0) { echo "{$user->name} has no friends :("; } else { echo "<br><br>{$user->name}'s friends"; } ?></small>
						</td>
					</tr>
				</table>
				
				<center>
				<?php

				if (Session::isAuthed() && $this->data->username != Session::auth()->username)  { 

					if (!UserDao::isFriend($this->data->username, Session::auth()->username)) {
				
					?><a href="{$site->url}/friend/request?username={$user->name}"><button class="btn btn-small btn-success" type="button">Request Friend</button></a><?php
					
					} else {
					
					?><a href="{$site->url}/friend/remove?username={$user->name}"><button class="btn btn-small btn-warning" type="button">Remove Friend</button></a><?php
					
					}

				}
				?>	
				</center>				

			</div>
		</div>
	
		<hr>
		
		<h3>Recent History <small>Displays the last 25 kills, deaths, cores leaked and monuments broken.</small></h3>

		<hr>
		
		<?php
		
		$first = UserDao::loadStdClass(R::getAll('SELECT * FROM `users_statistics` WHERE `from_id` = ? ORDER BY id DESC LIMIT 25', array($this->data->user->id)));
		$second = array();
		
		$i = 0;
		
		foreach ($first as $row) {
		
			$i++;
			
			if ($i > 25) {
				$second[] = $row;
			}
		}
		
		?>
		
		<div class="row">
		
			<div class="span12">
				<table class="table table-bordered">
					<tr>
						<td>

						<?php
						
						foreach ($first as $row) {
							if ($row->type == "kill") {
								$killer = UserDao::getId($row->from_id);
								$killed = UserDao::getId($row->to_id);
								$map = R::load("maps", $row->map_id);
								
								echo "<img class='avatar' src='https://minotar.net/helm/$killer->username/16' player='$killer->username' size='16' width='16' height='16' style='width: 16px; height: 16px; '/> <a href='{$site->url}/profile/$killer->username'>$killer->username</a> killed <a href='{$site->url}/profile/$killed->username'>$killed->username</a> on [" . $map->map_type . "] " . $map->map_name . " " . humanTiming($row->time) . " ago<br>";
							}
							
							if ($row->type == "death") {
								$killer = UserDao::getId($row->from_id);
								$killed = UserDao::getId($row->to_id);
								$map = R::load("maps", $row->map_id);
								
								echo "<img class='avatar' src='https://minotar.net/helm/$killed->username/16' player='$killed->username' size='16' width='16' height='16' style='width: 16px; height: 16px; '/> <a href='{$site->url}/profile/$killed->username'>$killed->username</a> killed <a href='{$site->url}/profile/$killer->username'>$killer->username</a> on [" . $map->map_type . "] " . $map->map_name . " " . humanTiming($row->time) . " ago<br>";
							}
							
							if ($row->type == "core") {
								$killer = UserDao::getId($row->from_id);
								$map = R::load("maps", $row->map_id);
								
								echo "<img class='avatar' src='https://minotar.net/helm/$killer->username/16' player='$killer->username' size='16' width='16' height='16' style='width: 16px; height: 16px; '/> <a href='{$site->url}/profile/$killer->username'>$killer->username</a> leaked core on [" . $map->map_type . "] " . $map->map_name . " " . humanTiming($row->time) . " ago<br>";
							}
							
							if ($row->type == "monument") {
								$killer = UserDao::getId($row->from_id);
								$map = R::load("maps", $row->map_id);
								
								echo "<img class='avatar' src='https://minotar.net/helm/$killer->username/16' player='$killer->username' size='16' width='16' height='16' style='width: 16px; height: 16px; '/> <a href='{$site->url}/profile/$killer->username'>$killer->username</a> destroyed monument on [" . $map->map_type . "] " . $map->map_name . " " . humanTiming($row->time) . " ago<br>";
							}
						}
						
						?>
						
						</td>
					</tr>
				</table>

			</div>
			
		</div>
	
		<hr>
	  
		<?php
		$this->inc("base/footer");
		?>
	  
    </div> <!-- /container -->
	
	<?php
	$this->inc("base/javascript");
	?>
	
	
  </body>
</html>