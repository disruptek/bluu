
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: NetworkManagementClient
## version: 2018-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to manage your network resources. The API has entities that capture the relationship between an end user and the Microsoft Azure Networks service.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_563539 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563539](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563539): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "network-vmssNetworkInterface"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_563761 = ref object of OpenApiRestCall_563539
proc url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_563763(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_563762(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets all network interfaces in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_563925 = path.getOrDefault("subscriptionId")
  valid_563925 = validateParameter(valid_563925, JString, required = true,
                                 default = nil)
  if valid_563925 != nil:
    section.add "subscriptionId", valid_563925
  var valid_563926 = path.getOrDefault("virtualMachineScaleSetName")
  valid_563926 = validateParameter(valid_563926, JString, required = true,
                                 default = nil)
  if valid_563926 != nil:
    section.add "virtualMachineScaleSetName", valid_563926
  var valid_563927 = path.getOrDefault("resourceGroupName")
  valid_563927 = validateParameter(valid_563927, JString, required = true,
                                 default = nil)
  if valid_563927 != nil:
    section.add "resourceGroupName", valid_563927
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563941 = query.getOrDefault("api-version")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_563941 != nil:
    section.add "api-version", valid_563941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563968: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_563761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all network interfaces in a virtual machine scale set.
  ## 
  let valid = call_563968.validator(path, query, header, formData, body)
  let scheme = call_563968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563968.url(scheme.get, call_563968.host, call_563968.base,
                         call_563968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563968, url, valid)

proc call*(call_564039: Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_563761;
          subscriptionId: string; virtualMachineScaleSetName: string;
          resourceGroupName: string; apiVersion: string = "2017-03-30"): Recallable =
  ## networkInterfacesListVirtualMachineScaleSetNetworkInterfaces
  ## Gets all network interfaces in a virtual machine scale set.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564040 = newJObject()
  var query_564042 = newJObject()
  add(query_564042, "api-version", newJString(apiVersion))
  add(path_564040, "subscriptionId", newJString(subscriptionId))
  add(path_564040, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_564040, "resourceGroupName", newJString(resourceGroupName))
  result = call_564039.call(path_564040, query_564042, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_563761(
    name: "networkInterfacesListVirtualMachineScaleSetNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_563762,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetNetworkInterfaces_563763,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_564081 = ref object of OpenApiRestCall_563539
proc url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_564083(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  assert "virtualmachineIndex" in path,
        "`virtualmachineIndex` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_564082(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets information about all network interfaces in a virtual machine in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564084 = path.getOrDefault("subscriptionId")
  valid_564084 = validateParameter(valid_564084, JString, required = true,
                                 default = nil)
  if valid_564084 != nil:
    section.add "subscriptionId", valid_564084
  var valid_564085 = path.getOrDefault("virtualMachineScaleSetName")
  valid_564085 = validateParameter(valid_564085, JString, required = true,
                                 default = nil)
  if valid_564085 != nil:
    section.add "virtualMachineScaleSetName", valid_564085
  var valid_564086 = path.getOrDefault("resourceGroupName")
  valid_564086 = validateParameter(valid_564086, JString, required = true,
                                 default = nil)
  if valid_564086 != nil:
    section.add "resourceGroupName", valid_564086
  var valid_564087 = path.getOrDefault("virtualmachineIndex")
  valid_564087 = validateParameter(valid_564087, JString, required = true,
                                 default = nil)
  if valid_564087 != nil:
    section.add "virtualmachineIndex", valid_564087
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564088 = query.getOrDefault("api-version")
  valid_564088 = validateParameter(valid_564088, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_564088 != nil:
    section.add "api-version", valid_564088
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564089: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_564081;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about all network interfaces in a virtual machine in a virtual machine scale set.
  ## 
  let valid = call_564089.validator(path, query, header, formData, body)
  let scheme = call_564089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564089.url(scheme.get, call_564089.host, call_564089.base,
                         call_564089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564089, url, valid)

proc call*(call_564090: Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_564081;
          subscriptionId: string; virtualMachineScaleSetName: string;
          resourceGroupName: string; virtualmachineIndex: string;
          apiVersion: string = "2017-03-30"): Recallable =
  ## networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces
  ## Gets information about all network interfaces in a virtual machine in a virtual machine scale set.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  var path_564091 = newJObject()
  var query_564092 = newJObject()
  add(query_564092, "api-version", newJString(apiVersion))
  add(path_564091, "subscriptionId", newJString(subscriptionId))
  add(path_564091, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_564091, "resourceGroupName", newJString(resourceGroupName))
  add(path_564091, "virtualmachineIndex", newJString(virtualmachineIndex))
  result = call_564090.call(path_564091, query_564092, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces* = Call_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_564081(
    name: "networkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces", validator: validate_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_564082,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetVMNetworkInterfaces_564083,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_564093 = ref object of OpenApiRestCall_563539
proc url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_564095(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  assert "virtualmachineIndex" in path,
        "`virtualmachineIndex` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_564094(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the specified network interface in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `networkInterfaceName` field"
  var valid_564097 = path.getOrDefault("networkInterfaceName")
  valid_564097 = validateParameter(valid_564097, JString, required = true,
                                 default = nil)
  if valid_564097 != nil:
    section.add "networkInterfaceName", valid_564097
  var valid_564098 = path.getOrDefault("subscriptionId")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "subscriptionId", valid_564098
  var valid_564099 = path.getOrDefault("virtualMachineScaleSetName")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "virtualMachineScaleSetName", valid_564099
  var valid_564100 = path.getOrDefault("resourceGroupName")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "resourceGroupName", valid_564100
  var valid_564101 = path.getOrDefault("virtualmachineIndex")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "virtualmachineIndex", valid_564101
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  var valid_564103 = query.getOrDefault("$expand")
  valid_564103 = validateParameter(valid_564103, JString, required = false,
                                 default = nil)
  if valid_564103 != nil:
    section.add "$expand", valid_564103
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564104: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_564093;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified network interface in a virtual machine scale set.
  ## 
  let valid = call_564104.validator(path, query, header, formData, body)
  let scheme = call_564104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564104.url(scheme.get, call_564104.host, call_564104.base,
                         call_564104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564104, url, valid)

proc call*(call_564105: Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_564093;
          networkInterfaceName: string; subscriptionId: string;
          virtualMachineScaleSetName: string; resourceGroupName: string;
          virtualmachineIndex: string; apiVersion: string = "2017-03-30";
          Expand: string = ""): Recallable =
  ## networkInterfacesGetVirtualMachineScaleSetNetworkInterface
  ## Get the specified network interface in a virtual machine scale set.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  var path_564106 = newJObject()
  var query_564107 = newJObject()
  add(query_564107, "api-version", newJString(apiVersion))
  add(path_564106, "networkInterfaceName", newJString(networkInterfaceName))
  add(query_564107, "$expand", newJString(Expand))
  add(path_564106, "subscriptionId", newJString(subscriptionId))
  add(path_564106, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_564106, "resourceGroupName", newJString(resourceGroupName))
  add(path_564106, "virtualmachineIndex", newJString(virtualmachineIndex))
  result = call_564105.call(path_564106, query_564107, nil, nil, nil)

var networkInterfacesGetVirtualMachineScaleSetNetworkInterface* = Call_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_564093(
    name: "networkInterfacesGetVirtualMachineScaleSetNetworkInterface",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}", validator: validate_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_564094,
    base: "", url: url_NetworkInterfacesGetVirtualMachineScaleSetNetworkInterface_564095,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesListVirtualMachineScaleSetIpConfigurations_564108 = ref object of OpenApiRestCall_563539
proc url_NetworkInterfacesListVirtualMachineScaleSetIpConfigurations_564110(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  assert "virtualmachineIndex" in path,
        "`virtualmachineIndex` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/ipConfigurations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesListVirtualMachineScaleSetIpConfigurations_564109(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the specified network interface ip configuration in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `networkInterfaceName` field"
  var valid_564111 = path.getOrDefault("networkInterfaceName")
  valid_564111 = validateParameter(valid_564111, JString, required = true,
                                 default = nil)
  if valid_564111 != nil:
    section.add "networkInterfaceName", valid_564111
  var valid_564112 = path.getOrDefault("subscriptionId")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "subscriptionId", valid_564112
  var valid_564113 = path.getOrDefault("virtualMachineScaleSetName")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "virtualMachineScaleSetName", valid_564113
  var valid_564114 = path.getOrDefault("resourceGroupName")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "resourceGroupName", valid_564114
  var valid_564115 = path.getOrDefault("virtualmachineIndex")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "virtualmachineIndex", valid_564115
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564116 = query.getOrDefault("api-version")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_564116 != nil:
    section.add "api-version", valid_564116
  var valid_564117 = query.getOrDefault("$expand")
  valid_564117 = validateParameter(valid_564117, JString, required = false,
                                 default = nil)
  if valid_564117 != nil:
    section.add "$expand", valid_564117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564118: Call_NetworkInterfacesListVirtualMachineScaleSetIpConfigurations_564108;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified network interface ip configuration in a virtual machine scale set.
  ## 
  let valid = call_564118.validator(path, query, header, formData, body)
  let scheme = call_564118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564118.url(scheme.get, call_564118.host, call_564118.base,
                         call_564118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564118, url, valid)

proc call*(call_564119: Call_NetworkInterfacesListVirtualMachineScaleSetIpConfigurations_564108;
          networkInterfaceName: string; subscriptionId: string;
          virtualMachineScaleSetName: string; resourceGroupName: string;
          virtualmachineIndex: string; apiVersion: string = "2017-03-30";
          Expand: string = ""): Recallable =
  ## networkInterfacesListVirtualMachineScaleSetIpConfigurations
  ## Get the specified network interface ip configuration in a virtual machine scale set.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  var path_564120 = newJObject()
  var query_564121 = newJObject()
  add(query_564121, "api-version", newJString(apiVersion))
  add(path_564120, "networkInterfaceName", newJString(networkInterfaceName))
  add(query_564121, "$expand", newJString(Expand))
  add(path_564120, "subscriptionId", newJString(subscriptionId))
  add(path_564120, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_564120, "resourceGroupName", newJString(resourceGroupName))
  add(path_564120, "virtualmachineIndex", newJString(virtualmachineIndex))
  result = call_564119.call(path_564120, query_564121, nil, nil, nil)

var networkInterfacesListVirtualMachineScaleSetIpConfigurations* = Call_NetworkInterfacesListVirtualMachineScaleSetIpConfigurations_564108(
    name: "networkInterfacesListVirtualMachineScaleSetIpConfigurations",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}/ipConfigurations", validator: validate_NetworkInterfacesListVirtualMachineScaleSetIpConfigurations_564109,
    base: "",
    url: url_NetworkInterfacesListVirtualMachineScaleSetIpConfigurations_564110,
    schemes: {Scheme.Https})
type
  Call_NetworkInterfacesGetVirtualMachineScaleSetIpConfiguration_564122 = ref object of OpenApiRestCall_563539
proc url_NetworkInterfacesGetVirtualMachineScaleSetIpConfiguration_564124(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "virtualMachineScaleSetName" in path,
        "`virtualMachineScaleSetName` is a required path parameter"
  assert "virtualmachineIndex" in path,
        "`virtualmachineIndex` is a required path parameter"
  assert "networkInterfaceName" in path,
        "`networkInterfaceName` is a required path parameter"
  assert "ipConfigurationName" in path,
        "`ipConfigurationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/ipConfigurations/"),
               (kind: VariableSegment, value: "ipConfigurationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkInterfacesGetVirtualMachineScaleSetIpConfiguration_564123(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the specified network interface ip configuration in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ipConfigurationName: JString (required)
  ##                      : The name of the ip configuration.
  ##   networkInterfaceName: JString (required)
  ##                       : The name of the network interface.
  ##   subscriptionId: JString (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: JString (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: JString (required)
  ##                      : The virtual machine index.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ipConfigurationName` field"
  var valid_564125 = path.getOrDefault("ipConfigurationName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "ipConfigurationName", valid_564125
  var valid_564126 = path.getOrDefault("networkInterfaceName")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "networkInterfaceName", valid_564126
  var valid_564127 = path.getOrDefault("subscriptionId")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = nil)
  if valid_564127 != nil:
    section.add "subscriptionId", valid_564127
  var valid_564128 = path.getOrDefault("virtualMachineScaleSetName")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "virtualMachineScaleSetName", valid_564128
  var valid_564129 = path.getOrDefault("resourceGroupName")
  valid_564129 = validateParameter(valid_564129, JString, required = true,
                                 default = nil)
  if valid_564129 != nil:
    section.add "resourceGroupName", valid_564129
  var valid_564130 = path.getOrDefault("virtualmachineIndex")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = nil)
  if valid_564130 != nil:
    section.add "virtualmachineIndex", valid_564130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564131 = query.getOrDefault("api-version")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_564131 != nil:
    section.add "api-version", valid_564131
  var valid_564132 = query.getOrDefault("$expand")
  valid_564132 = validateParameter(valid_564132, JString, required = false,
                                 default = nil)
  if valid_564132 != nil:
    section.add "$expand", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_NetworkInterfacesGetVirtualMachineScaleSetIpConfiguration_564122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified network interface ip configuration in a virtual machine scale set.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_NetworkInterfacesGetVirtualMachineScaleSetIpConfiguration_564122;
          ipConfigurationName: string; networkInterfaceName: string;
          subscriptionId: string; virtualMachineScaleSetName: string;
          resourceGroupName: string; virtualmachineIndex: string;
          apiVersion: string = "2017-03-30"; Expand: string = ""): Recallable =
  ## networkInterfacesGetVirtualMachineScaleSetIpConfiguration
  ## Get the specified network interface ip configuration in a virtual machine scale set.
  ##   ipConfigurationName: string (required)
  ##                      : The name of the ip configuration.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkInterfaceName: string (required)
  ##                       : The name of the network interface.
  ##   Expand: string
  ##         : Expands referenced resources.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(path_564135, "ipConfigurationName", newJString(ipConfigurationName))
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "networkInterfaceName", newJString(networkInterfaceName))
  add(query_564136, "$expand", newJString(Expand))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  add(path_564135, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_564135, "resourceGroupName", newJString(resourceGroupName))
  add(path_564135, "virtualmachineIndex", newJString(virtualmachineIndex))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var networkInterfacesGetVirtualMachineScaleSetIpConfiguration* = Call_NetworkInterfacesGetVirtualMachineScaleSetIpConfiguration_564122(
    name: "networkInterfacesGetVirtualMachineScaleSetIpConfiguration",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}/ipConfigurations/{ipConfigurationName}", validator: validate_NetworkInterfacesGetVirtualMachineScaleSetIpConfiguration_564123,
    base: "", url: url_NetworkInterfacesGetVirtualMachineScaleSetIpConfiguration_564124,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
