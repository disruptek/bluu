
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "network-vmssPublicIpAddress"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_563777 = ref object of OpenApiRestCall_563555
proc url_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_563779(
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
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/publicipaddresses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_563778(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets information about all public IP addresses on a virtual machine scale set level.
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
  var valid_563941 = path.getOrDefault("subscriptionId")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "subscriptionId", valid_563941
  var valid_563942 = path.getOrDefault("virtualMachineScaleSetName")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "virtualMachineScaleSetName", valid_563942
  var valid_563943 = path.getOrDefault("resourceGroupName")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "resourceGroupName", valid_563943
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563957 = query.getOrDefault("api-version")
  valid_563957 = validateParameter(valid_563957, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_563957 != nil:
    section.add "api-version", valid_563957
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563984: Call_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about all public IP addresses on a virtual machine scale set level.
  ## 
  let valid = call_563984.validator(path, query, header, formData, body)
  let scheme = call_563984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563984.url(scheme.get, call_563984.host, call_563984.base,
                         call_563984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563984, url, valid)

proc call*(call_564055: Call_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_563777;
          subscriptionId: string; virtualMachineScaleSetName: string;
          resourceGroupName: string; apiVersion: string = "2017-03-30"): Recallable =
  ## publicIPAddressesListVirtualMachineScaleSetPublicIPAddresses
  ## Gets information about all public IP addresses on a virtual machine scale set level.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564056 = newJObject()
  var query_564058 = newJObject()
  add(query_564058, "api-version", newJString(apiVersion))
  add(path_564056, "subscriptionId", newJString(subscriptionId))
  add(path_564056, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_564056, "resourceGroupName", newJString(resourceGroupName))
  result = call_564055.call(path_564056, query_564058, nil, nil, nil)

var publicIPAddressesListVirtualMachineScaleSetPublicIPAddresses* = Call_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_563777(
    name: "publicIPAddressesListVirtualMachineScaleSetPublicIPAddresses",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/publicipaddresses", validator: validate_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_563778,
    base: "",
    url: url_PublicIPAddressesListVirtualMachineScaleSetPublicIPAddresses_563779,
    schemes: {Scheme.Https})
type
  Call_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_564097 = ref object of OpenApiRestCall_563555
proc url_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_564099(
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
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/ipconfigurations/"),
               (kind: VariableSegment, value: "ipConfigurationName"),
               (kind: ConstantSegment, value: "/publicipaddresses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_564098(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets information about all public IP addresses in a virtual machine IP configuration in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ipConfigurationName: JString (required)
  ##                      : The IP configuration name.
  ##   networkInterfaceName: JString (required)
  ##                       : The network interface name.
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
  var valid_564100 = path.getOrDefault("ipConfigurationName")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "ipConfigurationName", valid_564100
  var valid_564101 = path.getOrDefault("networkInterfaceName")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "networkInterfaceName", valid_564101
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  var valid_564103 = path.getOrDefault("virtualMachineScaleSetName")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "virtualMachineScaleSetName", valid_564103
  var valid_564104 = path.getOrDefault("resourceGroupName")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "resourceGroupName", valid_564104
  var valid_564105 = path.getOrDefault("virtualmachineIndex")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "virtualmachineIndex", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_564097;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about all public IP addresses in a virtual machine IP configuration in a virtual machine scale set.
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_564097;
          ipConfigurationName: string; networkInterfaceName: string;
          subscriptionId: string; virtualMachineScaleSetName: string;
          resourceGroupName: string; virtualmachineIndex: string;
          apiVersion: string = "2017-03-30"): Recallable =
  ## publicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses
  ## Gets information about all public IP addresses in a virtual machine IP configuration in a virtual machine scale set.
  ##   ipConfigurationName: string (required)
  ##                      : The IP configuration name.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   networkInterfaceName: string (required)
  ##                       : The network interface name.
  ##   subscriptionId: string (required)
  ##                 : The subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   virtualMachineScaleSetName: string (required)
  ##                             : The name of the virtual machine scale set.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   virtualmachineIndex: string (required)
  ##                      : The virtual machine index.
  var path_564109 = newJObject()
  var query_564110 = newJObject()
  add(path_564109, "ipConfigurationName", newJString(ipConfigurationName))
  add(query_564110, "api-version", newJString(apiVersion))
  add(path_564109, "networkInterfaceName", newJString(networkInterfaceName))
  add(path_564109, "subscriptionId", newJString(subscriptionId))
  add(path_564109, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_564109, "resourceGroupName", newJString(resourceGroupName))
  add(path_564109, "virtualmachineIndex", newJString(virtualmachineIndex))
  result = call_564108.call(path_564109, query_564110, nil, nil, nil)

var publicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses* = Call_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_564097(
    name: "publicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}/ipconfigurations/{ipConfigurationName}/publicipaddresses", validator: validate_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_564098,
    base: "",
    url: url_PublicIPAddressesListVirtualMachineScaleSetVMPublicIPAddresses_564099,
    schemes: {Scheme.Https})
type
  Call_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_564111 = ref object of OpenApiRestCall_563555
proc url_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_564113(
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
  assert "publicIpAddressName" in path,
        "`publicIpAddressName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Compute/virtualMachineScaleSets/"),
               (kind: VariableSegment, value: "virtualMachineScaleSetName"),
               (kind: ConstantSegment, value: "/virtualMachines/"),
               (kind: VariableSegment, value: "virtualmachineIndex"),
               (kind: ConstantSegment, value: "/networkInterfaces/"),
               (kind: VariableSegment, value: "networkInterfaceName"),
               (kind: ConstantSegment, value: "/ipconfigurations/"),
               (kind: VariableSegment, value: "ipConfigurationName"),
               (kind: ConstantSegment, value: "/publicipaddresses/"),
               (kind: VariableSegment, value: "publicIpAddressName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_564112(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get the specified public IP address in a virtual machine scale set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   ipConfigurationName: JString (required)
  ##                      : The name of the IP configuration.
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
  ##   publicIpAddressName: JString (required)
  ##                      : The name of the public IP Address.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `ipConfigurationName` field"
  var valid_564115 = path.getOrDefault("ipConfigurationName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "ipConfigurationName", valid_564115
  var valid_564116 = path.getOrDefault("networkInterfaceName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "networkInterfaceName", valid_564116
  var valid_564117 = path.getOrDefault("subscriptionId")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "subscriptionId", valid_564117
  var valid_564118 = path.getOrDefault("virtualMachineScaleSetName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "virtualMachineScaleSetName", valid_564118
  var valid_564119 = path.getOrDefault("resourceGroupName")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "resourceGroupName", valid_564119
  var valid_564120 = path.getOrDefault("virtualmachineIndex")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "virtualmachineIndex", valid_564120
  var valid_564121 = path.getOrDefault("publicIpAddressName")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "publicIpAddressName", valid_564121
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  ##   $expand: JString
  ##          : Expands referenced resources.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564122 = query.getOrDefault("api-version")
  valid_564122 = validateParameter(valid_564122, JString, required = true,
                                 default = newJString("2017-03-30"))
  if valid_564122 != nil:
    section.add "api-version", valid_564122
  var valid_564123 = query.getOrDefault("$expand")
  valid_564123 = validateParameter(valid_564123, JString, required = false,
                                 default = nil)
  if valid_564123 != nil:
    section.add "$expand", valid_564123
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564124: Call_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_564111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the specified public IP address in a virtual machine scale set.
  ## 
  let valid = call_564124.validator(path, query, header, formData, body)
  let scheme = call_564124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564124.url(scheme.get, call_564124.host, call_564124.base,
                         call_564124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564124, url, valid)

proc call*(call_564125: Call_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_564111;
          ipConfigurationName: string; networkInterfaceName: string;
          subscriptionId: string; virtualMachineScaleSetName: string;
          resourceGroupName: string; virtualmachineIndex: string;
          publicIpAddressName: string; apiVersion: string = "2017-03-30";
          Expand: string = ""): Recallable =
  ## publicIPAddressesGetVirtualMachineScaleSetPublicIPAddress
  ## Get the specified public IP address in a virtual machine scale set.
  ##   ipConfigurationName: string (required)
  ##                      : The name of the IP configuration.
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
  ##   publicIpAddressName: string (required)
  ##                      : The name of the public IP Address.
  var path_564126 = newJObject()
  var query_564127 = newJObject()
  add(path_564126, "ipConfigurationName", newJString(ipConfigurationName))
  add(query_564127, "api-version", newJString(apiVersion))
  add(path_564126, "networkInterfaceName", newJString(networkInterfaceName))
  add(query_564127, "$expand", newJString(Expand))
  add(path_564126, "subscriptionId", newJString(subscriptionId))
  add(path_564126, "virtualMachineScaleSetName",
      newJString(virtualMachineScaleSetName))
  add(path_564126, "resourceGroupName", newJString(resourceGroupName))
  add(path_564126, "virtualmachineIndex", newJString(virtualmachineIndex))
  add(path_564126, "publicIpAddressName", newJString(publicIpAddressName))
  result = call_564125.call(path_564126, query_564127, nil, nil, nil)

var publicIPAddressesGetVirtualMachineScaleSetPublicIPAddress* = Call_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_564111(
    name: "publicIPAddressesGetVirtualMachineScaleSetPublicIPAddress",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachineScaleSets/{virtualMachineScaleSetName}/virtualMachines/{virtualmachineIndex}/networkInterfaces/{networkInterfaceName}/ipconfigurations/{ipConfigurationName}/publicipaddresses/{publicIpAddressName}", validator: validate_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_564112,
    base: "", url: url_PublicIPAddressesGetVirtualMachineScaleSetPublicIPAddress_564113,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
